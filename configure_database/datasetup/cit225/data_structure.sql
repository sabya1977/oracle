select object_name, object_type from dba_objects where owner = 'CIT225' order by 2;
--
OBJECT_NAME          OBJECT_TYPE    
____________________ ______________ 
PK_SYSTEM_USER_1     INDEX          
ADDRESS_N1           INDEX          
PK_ITEM_1            INDEX          
PK_RENTAL_1          INDEX          
PK_C_LOOKUP_1        INDEX          
COMMON_LOOKUP_N1     INDEX          
COMMON_LOOKUP_U2     INDEX          
TELEPHONE_N3         INDEX          
TELEPHONE_N2         INDEX          
PK_MEMBER_1          INDEX          
MEMBER_N1            INDEX          
TELEPHONE_N1         INDEX          
PK_TELEPHONE_1       INDEX          
PK_CONTACT_1         INDEX          
CONTACT_N1           INDEX          
CONTACT_N2           INDEX          
PK_S_ADDRESS_1       INDEX          
ADDRESS_N2           INDEX          
PK_ADDRESS_1         INDEX          
PK_RENTAL_ITEM_1     INDEX          
CONTACT_INSERT       PROCEDURE      
RENTAL_ITEM_S1       SEQUENCE       
COMMON_LOOKUP_S1     SEQUENCE       
STREET_ADDRESS_S1    SEQUENCE       
ITEM_S1              SEQUENCE       
TELEPHONE_S1         SEQUENCE       
MEMBER_S1            SEQUENCE       
RENTAL_S1            SEQUENCE       
CONTACT_S1           SEQUENCE       
ADDRESS_S1           SEQUENCE       
SYSTEM_USER_S1       SEQUENCE       
SYSTEM_USER          TABLE          
RENTAL_ITEM          TABLE          

OBJECT_NAME       OBJECT_TYPE    
_________________ ______________ 
ITEM              TABLE          
COMMON_LOOKUP     TABLE          
RENTAL            TABLE          
MEMBER            TABLE          
CONTACT           TABLE          
TELEPHONE         TABLE          
ADDRESS           TABLE          
STREET_ADDRESS    TABLE          
CURRENT_RENTAL    VIEW 
--
          
