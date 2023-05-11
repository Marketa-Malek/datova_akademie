# SQL_projekt

V tomto projektu se zabýváme otázkami růstu cen potravin a mezd. Pracujeme s daty z české republiky, které nám nabízí ceny potravin, jejich kategorie a množství. Data mzdová obsahují informace o mzdách a jednotlivých odvětví. Obě tabulky informace sbíraly v určitých časových obdobích.

Jako první bylo nutné vytvořit novou tabulku, která obsahuje pouze ty data, která opravdu potřebujeme. Zárověň jsme využili omezující podmínky, jako např. value type code, či hodnoty kterou jsou NULL. Pro finální tabulku byly použity a pospojovány data:
- czechia price
- czechia price category
- czechia payroll
- czechia payroll industry branch

Pro poslední otázku byla použita tabulka economies, ze které jsme využili informace GDP.


# **1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?**
  
   Co potřebuji vědět?
   - roky
   - mzdy
   - odvětví
   - využila jsem vytvořeného view z předchozí otázky pro snadnější tvoření příkazu

**Odpověď:** 
- Nejnižší nárůst byl v kategorii: Ubytování, stravování a pohostinství, a to 7 928 Kč. 
- Do 10 000 Kč byl nárůst v administrativě, peněžnictví a pojišťovnictví, ostatních činnostech a v oblasti nemovitostí. 
- Nejvyšší nárůst byl v informační a komunikační činnosti s 23 739 Kč. Zbylá odvětví měla nárůst od 10 000 do 16 876 Kč. 


# **2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?**

Co potřebuji vědět?
- category_code pro danou potravinu
- mzdy
- cenu potraviny
- vypsané roky

**Odpověď:**
- V prvním měřitelném roce (2006) bylo možné zakoupit 1 112 ks chleba a 1 340 l mléka. 
- Na konci měřitelného období bylo možné zakoupit  1 273 ks chleba a 1 551 l mléka.

# **3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?**

Co potřebuji vědet?
- napojení tabulek pomocí payroll_year pro spočítání meziročního růstu
- kategorie potravin
- cenu potravin
- meziroční nárůst v procentech
- využila jsem vytvořeného view z předchozí otázky pro snadnější tvoření příkazu

**Odpověď:**
- V záporných hodnotách má nevyšší číslo ( - 77) jogurt bílý netučný. 
- Nad -50% se nachází také minerální voda, pivo, mouka hladká pšeničná a mrkev. 
- Do -50% zde máme mléko, cukr krystal. chléb, banány, vejce slepičí a jablka. 
- V plusových hodnotách do 50% máme pomeranče, rýži, těstoviny s rajčaty a pečivo pšeničné bílé. 
- Nad 50% a do 100% růstu jsou papriky a kuřecí maso. 
- Nad 100% se nachází bílé víno, kapr živý a rostlinný tuk. 
- Nad 200% je to vepřová pečeně, šunkový salám, eidam sýr, máslo a s nejvyšším nárůstem 497% hovězí maso zadní bez kosti.**



# **4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší, než růst mezd (větší než 10 %)?**

Co potřebuji vědět?
- meziroční nárůsty mezd v procentech
- meziroční nárůsty cen v procentech
- rozdíl mezi procentuálními růsty
- využila jsem vytvořeného view z předchozí otázky pro snadnější tvoření příkazu

**Odpověď:**
- Ano, v roce 2007 a 2008 byl rozdíl v nárustu cen a mezd nad 10%.
	


# **5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?**

- zde jsem si napojila tabulku economies pro přidání dat s GDP
- napojení tabulky economies samu na sebe pro meziroční procentuální růst 
- využila jsem vytvořeného view z předchozí otázky pro snadnější tvoření příkazu

**Odpověď:**
- Na začátku sledovaného období měl GDP nárůst hodnotu 5.57. Mzdy měly hodnotu 10.48 a potraviny 0.28.
- Následující rok GDP kleslo a s ním i mzdy. Do mínusových hodnot šly cen potravin. 
- Hodnota GDP klesla v roce 2009. Ceny vzrostly zatímco mzdy zůstaly na podobné hodnotě.
- Od roku 2013 do 2015 GDP výrazně vzrostlo ( z -0.05 na 5.39). Zareagovaly ceny potravin, ale více mzdy a to výrazným nárůstem (na 7,33). 
- nárůst cen potravin se projevil až v následujícím roce s hodnotou 8.44
- na konci sledovaného období mělo GDP hodnotu 5.17 -- ceny klesly do mínusu a mzdy se snížily na 5.08
