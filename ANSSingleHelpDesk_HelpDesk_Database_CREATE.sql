-- ****************************************************
-- *                     Activity                     *
-- ****************************************************
create table Activity (
   id          int not null,
   name        char(16) not null,
   description char(256) not null,
   constraint PK_Activity primary key (id)
);


-- ****************************************************
-- *                   AssetCategory                  *
-- ****************************************************
create table AssetCategory (
   id   int not null,
   name char not null,
   constraint PK_AssetCategory primary key (id)
);


-- ****************************************************
-- *                    EmailDomain                   *
-- ****************************************************
create table EmailDomain (
   id            int not null,
   name          char(16) not null,
   suffix        char(8) not null,
   generationKey int not null,
   constraint PK_EmailDomain primary key (id)
);


-- ****************************************************
-- *                     PhoneCode                    *
-- ****************************************************
create table PhoneCode (
   id           int not null,
   code         int not null,
   numberLength int not null,
   constraint PK_PhoneCode primary key (id)
);


-- ****************************************************
-- *                  AssetChangeType                 *
-- ****************************************************
create table AssetChangeType (
   id   int not null,
   name char(16) not null,
   constraint PK_AssetChangeType primary key (id)
);


-- ****************************************************
-- *                 ServiceCatalogue                 *
-- ****************************************************
create table ServiceCatalogue (
   id          int not null,
   name        char(16) not null,
   description char(256) not null,
   constraint PK_ServiceCatalogue primary key (id)
);


-- ****************************************************
-- *                       Role                       *
-- ****************************************************
create table Role (
   id   int not null,
   name char(16) not null,
   constraint PK_Role primary key (id)
);


-- ****************************************************
-- *                     AssetType                    *
-- ****************************************************
create table AssetType (
   id   int not null,
   name char(16) not null,
   constraint PK_AssetType primary key (id)
);


-- ****************************************************
-- *                     Producer                     *
-- ****************************************************
create table Producer (
   id   int not null,
   name char(32) not null,
   constraint PK_Producer primary key (id)
);


-- ****************************************************
-- *                        Tag                       *
-- ****************************************************
create table Tag (
   id   int not null,
   name char(16) not null,
   constraint PK_Tag primary key (id)
);


-- ****************************************************
-- *                     Location                     *
-- ****************************************************
create table Location (
   id   int not null,
   name char(16) not null,
   GPS  decimal(15,10) not null,
   constraint PK_Location primary key (id)
);


-- ****************************************************
-- *                       User                       *
-- ****************************************************
create table User (
   id       int not null,
   username char(8) not null,
   name     char(16) not null,
   surname  char(16) not null,
   password char(64) not null,
   role     int not null,
   room     int not null,
   constraint PK_User primary key (id)
);

alter table User
   add constraint User Has Role
   foreign key (role) references Role (id);

alter table User
   add constraint There are users in the office
   foreign key (room) references Location (id);


-- ****************************************************
-- *                       Asset                      *
-- ****************************************************
create table Asset (
   id           int not null,
   name         char(32) not null,
   category     int not null,
   type         int not null,
   controller   int not null,
   location     int not null,
   GPS          decimal(15,10) not null,
   producer     int not null,
   acquisition  datetime not null,
   serialNumber char(16) not null,
   constraint PK_Asset primary key (id)
);

alter table Asset
   add constraint The type of the asset is
   foreign key (type) references AssetType (id);

alter table Asset
   add constraint The asset has category
   foreign key (category) references AssetCategory (id);

alter table Asset
   add constraint The assets producer is
   foreign key (producer) references Producer (id);

alter table Asset
   add constraint The asset location is
   foreign key (location) references Location (id);

alter table Asset
   add constraint The user controlls assets
   foreign key (controller) references User (id);


-- ****************************************************
-- *                   Announcement                   *
-- ****************************************************
create table Announcement (
   id      int not null,
   name    char(64) not null,
   body    char(1024) not null,
   author  int not null,
   created datetime not null,
   constraint PK_Announcement primary key (id)
);

alter table Announcement
   add constraint User Wrote Announcement
   foreign key (author) references User (id);


-- ****************************************************
-- *                    AssetChange                   *
-- ****************************************************
create table AssetChange (
   id        int not null,
   author    int not null,
   recipient int,
   type      int not null,
   constraint PK_AssetChange primary key (id)
);

alter table AssetChange
   add constraint Type of the change
   foreign key (type) references AssetChangeType (id);

alter table AssetChange
   add constraint Author of the Change
   foreign key (author) references User (id);

alter table AssetChange
   add constraint Recipient of the Change
   foreign key (recipient) references User (id);


-- ****************************************************
-- *                   UserTagOwner                   *
-- ****************************************************
create table UserTagOwner (
   id    int not null,
   owner int not null,
   tag   int not null,
   constraint PK_UserTag primary key (id)
);

alter table UserTagOwner
   add constraint User Tags
   foreign key (owner) references User (id);

alter table UserTagOwner
   add constraint Tagged by Tag
   foreign key (tag) references Tag (id);


-- ****************************************************
-- *                      Ticket                      *
-- ****************************************************
create table Ticket (
   id          int not null,
   name        char(32),
   description char(256),
   created     datetime not null,
   author      int not null,
   solver      int not null,
   service     int,
   asset       int not null,
   status      int not null,
   priority    int not null,
   constraint PK_Ticket primary key (id)
);

alter table Ticket
   add constraint a service is requested
   foreign key (service) references ServiceCatalogue (id);

alter table Ticket
   add constraint The user created a ticket
   foreign key (author) references User (id);

alter table Ticket
   add constraint The ticket is assigned a solver
   foreign key (solver) references User (id);

alter table Ticket
   add constraint The ticket targets the asset
   foreign key (asset) references Asset (id);


-- ****************************************************
-- *                       Error                      *
-- ****************************************************
create table Error (
   id          int not null,
   name        char(16) not null,
   description char(256) not null,
   source      int not null,
   constraint PK_Error primary key (id)
);

alter table Error
   add constraint Activity ended with an Error
   foreign key (source) references Activity (id);


-- ****************************************************
-- *                 ActivityInTicket                 *
-- ****************************************************
create table ActivityInTicket (
   id          int not null,
   activity    int not null,
   ticket      int not null,
   time        datetime not null,
   user        int not null,
   description char(256),
   constraint PK_ActivityInTicket primary key (id)
);

alter table ActivityInTicket
   add constraint activity performed
   foreign key (activity) references Activity (id);

alter table ActivityInTicket
   add constraint who did the activity
   foreign key (user) references User (id);

alter table ActivityInTicket
   add constraint Activities made during solution of the ticket
   foreign key (ticket) references Ticket (id);


-- ****************************************************
-- *                       Email                      *
-- ****************************************************
create table Email (
   id       int not null,
   name     char(16) not null,
   domain   int not null,
   user     int not null,
   priority int not null,
   constraint PK_Email primary key (id)
);

alter table Email
   add constraint Email is under Domain
   foreign key (domain) references EmailDomain (id);

alter table Email
   add constraint User Has Email
   foreign key (user) references User (id);


-- ****************************************************
-- *                      Invoice                     *
-- ****************************************************
create table Invoice (
   id     int not null,
   change int not null,
   link   char(64) not null,
   constraint PK_Invoice primary key (id)
);

alter table Invoice
   add constraint The change has invoice
   foreign key (change) references AssetChange (id);


-- ****************************************************
-- *                   ChangedAsset                   *
-- ****************************************************
create table ChangedAsset (
   id     int not null,
   asset  int not null,
   change int not null,
   constraint PK_ChangedAsset primary key (id)
);

alter table ChangedAsset
   add constraint Assets targeted by Change
   foreign key (asset) references Asset (id);

alter table ChangedAsset
   add constraint Change targeting Assets
   foreign key (change) references AssetChange (id);


-- ****************************************************
-- *                      Message                     *
-- ****************************************************
create table Message (
   id        int not null,
   ticket    int not null,
   author    int not null,
   recipient int not null,
   body      char(128) not null,
   send      datetime not null,
   constraint PK_Message primary key (id)
);

alter table Message
   add constraint A comment on a ticket
   foreign key (ticket) references Ticket (id);

alter table Message
   add constraint A user wrote a message
   foreign key (author) references User (id);

alter table Message
   add constraint A user recieved a message
   foreign key (recipient) references User (id);


-- ****************************************************
-- *                       Phone                      *
-- ****************************************************
create table Phone (
   id       int not null,
   code     int not null,
   number   char(9) not null,
   user     int not null,
   priority int not null,
   constraint PK_Phone primary key (id)
);

alter table Phone
   add constraint Phone Has Code
   foreign key (code) references PhoneCode (id);

alter table Phone
   add constraint User Has Phone
   foreign key (user) references User (id);


-- ****************************************************
-- *                    Permission                    *
-- ****************************************************
create table Permission (
   id         int not null,
   activity   int not null,
   role       int not null,
   permission int not null,
   constraint PK_Permission primary key (id)
);

alter table Permission
   add constraint Role Has Permissions
   foreign key (role) references Role (id);

alter table Permission
   add constraint Permissions to perform an Anctivity
   foreign key (activity) references Activity (id);


-- ****************************************************
-- *                        Log                       *
-- ****************************************************
create table Log (
   id       int not null,
   user     int not null,
   activity int,
   error    int,
   time     datetime not null,
   constraint PK_Log primary key (id)
);

alter table Log
   add constraint User did
   foreign key (user) references User (id);

alter table Log
   add constraint Log logged Activity
   foreign key (activity) references Activity (id);

alter table Log
   add constraint Logged Error
   foreign key (error) references Error (id);


-- ****************************************************
-- *                   UserTagTarget                  *
-- ****************************************************
create table UserTagTarget (
   id     int not null,
   tag    int not null,
   target int not null,
   constraint PK_UserTagTarget primary key (id)
);

alter table UserTagTarget
   add constraint Tag Targets
   foreign key (tag) references UserTagOwner (id);

alter table UserTagTarget
   add constraint User is Tagged by
   foreign key (target) references User (id);


-- ****************************************************
-- *                   ServicedAsset                  *
-- ****************************************************
create table ServicedAsset (
   id      int not null,
   service int not null,
   asset   int not null,
   constraint PK_ServicedAsset primary key (id)
);

alter table ServicedAsset
   add constraint service targets asset
   foreign key (asset) references Asset (id);

alter table ServicedAsset
   add constraint The service is provided to assets
   foreign key (service) references ServiceCatalogue (id);


-- ****************************************************
-- *                  AnnouncementTag                 *
-- ****************************************************
create table AnnouncementTag (
   id           int not null,
   tag          int not null,
   announcement int not null,
   constraint PK_AnnouncementTag primary key (id)
);

alter table AnnouncementTag
   add constraint Announcement Tagged by
   foreign key (announcement) references Announcement (id);

alter table AnnouncementTag
   add constraint Tag Name
   foreign key (tag) references Tag (id);


