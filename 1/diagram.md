erDiagram

post {
    int id PK
    int user_id FK
    string name
    time date
    integer views_count 
    string content  
}

user {
    int id PK
    string mail UK
    string username UK
    string password 
}

reaction {
    int id PK
    int user_id FK
    int post_id FK
    string type
}

comment {
    int id PK
    int user_id FK
    int post_id FK
    string content
    time date
}

post }o--|| user: ""
post ||--o{ reaction: ""
post ||--o{ comment: ""
comment }o--o| user: ""
user |o--o{ reaction: ""
