-- tao va su dung Database
create database AssignmentDEP302;
use AssignmentDEP302;

-- xoa table neu da ton tai
drop table if exists fact_Pets;
drop table if exists dim_Breed;
drop table if exists dim_Color;
drop table if exists dim_HealthConditions;
drop table if exists dim_Rescuer;

-- lan luot tao cac table tuong ung
create table dim_Breed (
	BreedID int identity(1,1) primary key,
	Breed1 varchar(255),
	Breed2 varchar(255)
);

create table dim_Color (
	ColorID int identity(1,1) primary key,
	Color1 varchar(255),
	Color2 varchar(255),
	Color3 varchar(255)
);

create table dim_HealthConditions (
	HealthConditionsID int identity(1,1) primary key,
	Vaccinated varchar(50),
	Dewormed varchar(50),
	Sterilized varchar(50),
	Health varchar(50) 
);

create table dim_Rescuer (
	RescuerID int identity(1,1) primary key,
	Rescuer_IDName varchar(255)
);

create table fact_Pets (
	PetID int,
	BreedID int,
	ColorID int,
	HealthConditionsID int,
	RescuerID int,
	Type varchar(50),
	Age int,
	Gender varchar(50),
	MaturitySize varchar(50),
	FurLength varchar(50),
	Quantity int,
	Fee int,
	State varchar(255),
	primary key (PetID, BreedID, ColorID, HealthConditionsID, RescuerID)
);

-- rang buoc foreign key cho bang fact
alter table fact_Pets
add foreign key (BreedID) references dim_Breed(BreedID);

alter table fact_Pets
add foreign key (ColorID) references dim_Color(ColorID);

alter table fact_Pets
add foreign key (HealthConditionsID) references dim_HealthConditions(HealthConditionsID);

alter table fact_Pets
add foreign key (RescuerID) references dim_Rescuer(RescuerID);

-- xoa du lieu trong table truoc khi ETL
truncate table fact_Pets;
delete from dim_Breed;
delete from dim_Color;
delete from dim_HealthConditions;
delete from dim_Rescuer;

-- xem du lieu trong table
select * from fact_Pets;
select * from dim_Breed;
select * from dim_Color;
select * from dim_HealthConditions;
select * from dim_Rescuer;

-------------------------------------
-- Liet ke cac NGHIEP VU TRUY VAN
-------------------------------------

-- 01. Xac dinh thu cung nao bo phien nhat
select top 1
  Type,
  count(*) as Total
from fact_Pets
group by Type
order by Total desc;


-- 02. Xac dinh do tuoi trung binh cua tung thu cung
select 
	Type,
	avg(Age) as Average_Age
from fact_Pets
group by Type
order by Average_Age desc;


-- 03. Co bao nhieu thu cung trong tung state
select 
	State,
	Type,
	count(*) as Total
from fact_Pets
group by State, Type
order by State, Type, Total desc;


-- 04. Co bao nhieu thu da duoc tiem phong va triet san
select 
	pet.Type,
	count(*) as Total
from fact_Pets as pet
inner join dim_HealthConditions as heal on pet.HealthConditionsID = heal.HealthConditionsID
where heal.Vaccinated = 'Yes' and heal.Sterilized = 'Yes'
group by pet.Type
order by Total;


-- 05. Giong chinh cua vat nuoi nao co phi nuoi cao nhat
select 
	pet.Type,
	bre.Breed1,
	pet.Fee
from fact_Pets as pet
inner join dim_Breed as bre on pet.BreedID = bre.BreedID
inner join (
	select 
		pet.Type,
		max(pet.Fee) as Max_Fee
	from fact_Pets as pet
	inner join dim_Breed as bre on pet.BreedID = bre.BreedID
	group by pet.Type
) as pet1 on pet.Fee = pet1.Max_Fee
where pet.Type = pet1.Type
order by pet.Fee desc;


