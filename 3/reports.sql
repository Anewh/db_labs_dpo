-- Статус заказа | Среднее время пребывания заказа в этом статусе
with epochs as (
    select
        s.name as status,
        abs(
            coalesce(
                extract(
                    epoch
                    from
                        coalesce(
                            lead(oh.created_at) over (
                                partition by oh.order_id
                                order by
                                    oh.created_at
                            ),
                            now()
                        ) - oh.created_at
                ),
                0
            )
        ) as epochs
    from
        order_history oh
        inner join status s on s.id = oh.new_value :: int
    where
        oh.field_name = 'status_id'
)
select
    e.status as status,
    round(avg(e.epochs), 2) as avg
from
    epochs e
group by
    e.status;
-------------------------------------------------------------------------------------------------------
-- ID клиента | Дата последнего визита
select
    cv.customer_id as customer_id,
    max(cv.created_at) as last_visit
from
    customer_visit as cv
group by
    customer_id
order by
    last_visit asc;

-- ID клиента | Среднее количество просмотров страниц за визит
with visit_count as (
    select
        cv.customer_id as customer_id,
        cvp.visit_id as visit_id,
        count(cvp.id) as pages_count_per_visit
    from
        customer_visit_page as cvp
        inner join customer_visit as cv on cv.id = cvp.visit_id
    group by
        customer_id,
        visit_id
)
select
    customer_id,
    round(avg(pages_count_per_visit), 2) as avg_pages_per_visit
from
    visit_count
group by
    customer_id;

-- ID клиента | Адреса страниц с визитами дольше среднего времени визита этого клиента
WITH avg_time_on_pages AS (
    SELECT
        cv.customer_id AS customer_id,
        cvp.visit_id AS visit_id,
        avg(cvp.time_on_page) AS avg_time_on_page
    FROM
        customer_visit_page AS cvp
        INNER JOIN customer_visit AS cv ON cv.id = cvp.visit_id
    GROUP BY
        customer_id,
        visit_id
)
SELECT
    atp.customer_id AS customer_id,
    cvp.page AS page
FROM
    avg_time_on_pages AS atp
    INNER JOIN customer_visit_page AS cvp ON cvp.visit_id = atp.visit_id
WHERE
    cvp.time_on_page > atp.avg_time_on_page
ORDER BY
    customer_id;

-------------------------------------------------------------------------------------------------------
-- ID клиента | Среднее время между заказами
with report as (
    select
        o.customer_id as customer_id,
        extract(
            epoch
            from
                lag(o.created_at) over (
                    partition by o.customer_id
                    order by
                        o.created_at desc
                ) - o.created_at
        ) as epochs
    from
        "order" o
)
select
    c.id as customer_id,
    round(coalesce(avg(r.epochs), 0), 2) as average
from
    customer c
    left join report r on r.customer_id = c.id
group by
    c.id
order by
    c.id;

-- ID клиента | Количество визитов | Количество заказов
with visits as (
    select
        cv.customer_id as customer_id,
        count(cvp.visit_id) as count
    from
        customer_visit cv
        inner join customer_visit_page cvp on cv.id = cvp.visit_id
    group by
        cv.customer_id
),
orders as (
    select
        o.customer_id as customer_id,
        count(o.id) as count
    from
        "order" o
    group by
        o.customer_id
)
select
    c.id as customer_id,
    v.count as visits,
    o.count as orders
from
    customer c
    left join orders o on o.customer_id = c.id
    left join visits v on v.customer_id = c.id
order by
    c.id;

-- Источник трафика | Количество визитов с этим источником | Количество созданных заказов | Количество оплаченных(принятых) заказов | Количество выполненных заказов
with visits as (
    select
        cv.utm_source as utm_source,
        count(cvp.visit_id) as visits
    from
        customer_visit cv
        inner join customer_visit_page cvp on cv.id = cvp.visit_id
    group by
        cv.utm_source
),
orders as (
    select
        o.utm_source as utm_source,
        count(o.id) as count_orders
    from
        "order" o
    group by
        o.utm_source
),
payed as (
    select
        o.utm_source as utm_source,
        count(o.id) as count_orders
    from
        "order" o
    where
        o.status_id = 3
    group by
        o.utm_source
),
completed as (
    select
        o.utm_source as utm_source,
        count(o.id) as count_orders
    from
        "order" o
    where
        o.status_id = 7
    group by
        o.utm_source
)
select
    coalesce(o.utm_source, v.utm_source) as utm_source,
    coalesce(v.visits, 0) as visits_count,
    coalesce(o.count_orders, 0) as count_orders,
    coalesce(p.count_orders, 0) as payed_count,
    coalesce(c.count_orders, 0) as completed_count
from
    visits v
    left join orders o on v.utm_source = o.utm_source
    left join payed p on (p.utm_source = o.utm_source)
    left join completed c on c.utm_source = o.utm_source;

-- 3.3 ID менеджера | Среднее время выполнения заказов | Доля отмененных заказов | Сумма выполненных заказов | Средняя стоимость заказа
with completed as (
    select
        distinct o.id as order_id,
        extract(
            epoch
            from
                last_value(coh.created_at) over (partition by coh.order_id) - first_value(coh.created_at) over (partition by coh.order_id)
        ) as epochs,
        o.total_sum as total_sum
    from
        "order" o
        inner join order_history coh on o.id = coh.order_id
    where
        o.status_id = 1
),
uncompleted as (
    select
        o.id as id
    from
        "order" o
        inner join status cs on cs.id = o.status_id
        and status_id = 10
)
select
    o.manager_id as manager_id,
    coalesce(
        avg(c.epochs),
        0
    ) as avg_completed_time,
    round(count(u.id), 2) / round(count(o.id), 2) as fraction,
    round(
        coalesce(
            sum(c.total_sum),
            0
        ),
        2
    ) as completed_sum,
    round(avg(o.total_sum), 2) as average_cost
from
    "order" o
    left join completed c on o.id = c.order_id
    left join uncompleted u on u.id = o.id
group by
    o.manager_id
order by
    o.manager_id;

-- 3.3 ID менеджера | Рейтинг менеджера
with managers as (
    select
        distinct o.manager_id as manager_id
    from
        "order" o
    order by
        o.manager_id
),
orders as (
    select
        o.id as order_id,
        o.manager_id as manager_id
    from
        "order" o
),
completed as (
    select
        o.id as order_id,
        o.manager_id as manager_id
    from
        "order" o
    where
        o.status_id = 7
),
canceled as (
    select
        o.id as order_id,
        o.manager_id as manager_id
    from
        "order" o
    where
        o.status_id = 8
),
complete_time as (
    select
        distinct o.manager_id as manager_id,
        extract(
            epoch
            from
                last_value(coh.created_at) over (partition by coh.order_id) - first_value(coh.created_at) over (partition by coh.order_id)
        ) as epochs,
        o.total_sum as total_sum
    from
        "order" o
        inner join order_history coh on o.id = coh.order_id
    where
        o.status_id = 3
),
report as (
    select
        distinct m.manager_id as manager_id,
        coalesce(count(c.order_id) over w, 0) :: numeric(11, 2) - coalesce(count(c.order_id) over (), 0) :: numeric(11, 2) as completed_count,
        coalesce(avg(ct.epochs) over w, 0) :: numeric(11, 2) - coalesce(avg(ct.epochs) over (), 0) :: numeric(11, 2) as average_time,
        coalesce(count(cn.order_id) over w, 0) :: numeric(11, 2) - coalesce(count(cn.order_id) over (), 0) :: numeric(11, 2) as canceled_count
    from
        managers m
        inner join orders o on o.manager_id = m.manager_id
        left join completed c on c.manager_id = m.manager_id
        left join canceled cn on cn.manager_id = m.manager_id
        left join complete_time ct on ct.manager_id = m.manager_id window w as (partition by m.manager_id)
)
select
    r.manager_id,
    (
        r.completed_count + r.average_time + r.canceled_count
    ) as rate
from
    report r;