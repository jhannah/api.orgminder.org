
create table ents (
   id INTEGER PRIMARY KEY,
   type TEXT,      -- person, chair, set, ... 
   name TEXT,
   details TEXT    -- pile of json
);



/* 
===================================================================
Begin tree functions.

From: 
   http://sqlite.1065341.n5.nabble.com/Managing-trees-in-the-database-td6694.html Philipp Knüsel
(but heavily modified)


  -- Sample materialized path implementation of a tree in SQL 
    -- 
    -- The materialized path is a string containing the path to the node 
    -- represented by the node ids along the path separated by / characters. 
    -- This string is easy to search using the LIKE comparison function 
    -- to check for path characteristics. All the methods that apply to the 
    -- adjacency list representation can also be used with this format. 
    -- The path string is maintained automatically by triggers. Any node 
    -- inserted with a NULL parent_id is the root of a new tree. 
*/

    create table trees ( 
      id        integer primary key, 
      owner_id  integer references ents(id),
      tree_id   integer,
      parent_id integer references tree(id), 
      ent_id    integer, 
      path      text        -- materialized path 
    ); 
      
    -- set path to node when it is inserted 
    create trigger trees_in after insert on trees
    begin 
        update trees set path = 
            case when parent_id isnull then '/' 
            else (select path from trees where id = new.parent_id) || parent_id || '/' 
            end 
        where id = new.id; 
    end; 

    -- delete subtree below node when a node is deleted 
    create trigger trees_del before delete on trees
    begin 
        delete from tree where id in 
            (select id from trees
            where tree_id = old.tree_id 
            and path like old.path || old.id || '/%'); 
    end; 

/* 
    -- example 
    insert into trees (id, parent_id, ent_id) values (1, NULL, 'parent'); 
    insert into trees (id, parent_id, ent_id) values (NULL, 1, 'son'); 
    insert into trees (id, parent_id, ent_id) values (NULL, 1, 'daughter'); 
    insert into trees (id, parent_id, ent_id) values (NULL, 2, 'grandchild'); 
    select * from trees; 

    -- find all root nodes 
    select * from trees where parent_id isnull; 

    -- find all leaf nodes 
    select * from trees where id not in (select parent_id from tree); 

    -- find all nodes in the sub tree below node 
    select * from trees 
    where path like (select path || id || '/%' from tree where id = 
:node_id); 

    -- find all nodes along the path to node 
    select * from trees 
    where (select path || id || '/' from tree where id = :node_id) 
        like path || id || '/%' 
    order by path; 

    -- find all nodes on level 3 or 4 
    select * from trees 
    where path like '/%/%/' or path like '/%/%/%/'; 
===================================================================
*/



