-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ptu_interfaces_v (cd_interface, ds_interface, ie_tipo_interface, ds_versao_ptu, ie_versao_ptu, nr_versao_ptu) AS select	cd_interface cd_interface,
	ds_interface ds_interface,
	'A100' ie_tipo_interface,
	cd_tipo_interface ds_versao_ptu,
	replace(cd_tipo_interface,'PTU','') ie_versao_ptu,
	lpad(somente_numero(cd_tipo_interface),3,'0') nr_versao_ptu
FROM	interface
where	cd_interface in (1710, 2051, 2312, 2452, 2590, 2644, 2692, 2762)

union all

select	cd_interface cd_interface, 
	ds_interface ds_interface,
	'A200' ie_tipo_interface,
	cd_tipo_interface ds_versao_ptu,
	replace(cd_tipo_interface,'PTU','') ie_versao_ptu,
	lpad(somente_numero(cd_tipo_interface),3,'0') nr_versao_ptu
from	interface
where	cd_interface in (1744, 2052, 2483, 2591, 2757, 2785)

union all

select	cd_interface cd_interface, 
	ds_interface ds_interface,
	'A300' ie_tipo_interface,
	cd_tipo_interface ds_versao_ptu,
	replace(cd_tipo_interface,'PTU','') ie_versao_ptu,
	lpad(somente_numero(cd_tipo_interface),3,'0') nr_versao_ptu
from	interface
where	cd_interface in (1747, 1905, 1906, 1943, 1964, 2763)

union all

select	cd_interface cd_interface, 
	ds_interface ds_interface,
	'A400' ie_tipo_interface,
	cd_tipo_interface ds_versao_ptu,
	replace(cd_tipo_interface,'PTU','') ie_versao_ptu,
	lpad(somente_numero(cd_tipo_interface),3,'0') nr_versao_ptu
from	interface
where	cd_interface in (1753, 1960, 2050, 2319, 2477, 2583, 2647, 2689, 2751, 2786, 2831, 2922, 2977, 3083)

union all

select	cd_interface cd_interface, 
	ds_interface ds_interface,
	'A450' ie_tipo_interface,
	cd_tipo_interface ds_versao_ptu,
	replace(cd_tipo_interface,'PTU','') ie_versao_ptu,
	lpad(somente_numero(cd_tipo_interface),3,'0') nr_versao_ptu
from	interface
where	cd_interface in (2085, 2324, 2479, 2516, 2690, 2752, 2781, 2923)

union all

select	cd_interface cd_interface, 
	ds_interface ds_interface,
	'A500' ie_tipo_interface,
	cd_tipo_interface ds_versao_ptu,
	replace(cd_tipo_interface,'PTU','') ie_versao_ptu,
	lpad(somente_numero(cd_tipo_interface),3,'0') nr_versao_ptu
from	interface
where	cd_interface in ( 2153, 2350, 2472, 2574, 2585, 2637, 2698, 2745, 2767, 2789, 2791, 2833, 2836, 2906, 2907, 2924, 2925, 2940, 2976, 3066, 3091)

union all

select	cd_interface cd_interface, 
	ds_interface ds_interface,
	'A550' ie_tipo_interface,
	cd_tipo_interface ds_versao_ptu,
	replace(cd_tipo_interface,'PTU','') ie_versao_ptu,
	lpad(somente_numero(cd_tipo_interface),3,'0') nr_versao_ptu
from	interface
where	cd_interface in (1973, 2188, 2349, 2435, 2480, 2575, 2588, 2699, 2746, 2790, 2834, 2908, 2978, 3092)

union all

select	cd_interface cd_interface, 
	ds_interface ds_interface,
	'A560' ie_tipo_interface,
	cd_tipo_interface ds_versao_ptu,
	replace(cd_tipo_interface,'PTU','') ie_versao_ptu,
	lpad(somente_numero(cd_tipo_interface),3,'0') nr_versao_ptu
from	interface
where	cd_interface in (2184, 2351, 2436, 2481, 2576, 2589, 2747, 2782)

union all

select	cd_interface cd_interface, 
	ds_interface ds_interface,
	'A580' ie_tipo_interface,
	cd_tipo_interface ds_versao_ptu,
	replace(cd_tipo_interface,'PTU','') ie_versao_ptu,
	lpad(somente_numero(cd_tipo_interface),3,'0') nr_versao_ptu
from	interface
where	cd_interface in (2713, 2780, 2909, 2979)

union all

select	cd_interface cd_interface, 
	ds_interface ds_interface,
	'A600' ie_tipo_interface,
	cd_tipo_interface ds_versao_ptu,
	replace(cd_tipo_interface,'PTU','') ie_versao_ptu,
	lpad(somente_numero(cd_tipo_interface),3,'0') nr_versao_ptu
from	interface
where	cd_interface in (1841, 2298, 2357, 2478, 2584, 2810)

union all

select	cd_interface cd_interface, 
	ds_interface ds_interface,
	'A700' ie_tipo_interface,
	cd_tipo_interface ds_versao_ptu,
	replace(cd_tipo_interface,'PTU','') ie_versao_ptu,
	lpad(somente_numero(cd_tipo_interface),3,'0') nr_versao_ptu
from	interface
where	cd_interface in (1870, 1871, 1951, 1963, 2097, 2241, 2369, 2456, 2587, 2638, 2788 ,2835, 2926, 2941, 2980, 3074, 3090,3230, 10083)

union all

select	cd_interface cd_interface, 
	ds_interface ds_interface,
	'A800' ie_tipo_interface,
	cd_tipo_interface ds_versao_ptu,
	replace(cd_tipo_interface,'PTU','') ie_versao_ptu,
	lpad(somente_numero(cd_tipo_interface),3,'0') nr_versao_ptu
from	interface
where	cd_interface in (2266, 2473, 2593, 2666)

union all

select	cd_interface cd_interface, 
	ds_interface ds_interface,
	'A1200' ie_tipo_interface,
	cd_tipo_interface ds_versao_ptu,
	replace(cd_tipo_interface,'PTU','') ie_versao_ptu,
	lpad(somente_numero(cd_tipo_interface),3,'0') nr_versao_ptu
from	interface
where	cd_interface in (2183, 2750, 2787, 2837,3073, 3153,3232,10107)

union all

select	cd_interface cd_interface, 
	ds_interface ds_interface,
	'A410' ie_tipo_interface,
	cd_tipo_interface ds_versao_ptu,
	replace(cd_tipo_interface,'PTU','') ie_versao_ptu,
	lpad(somente_numero(cd_tipo_interface),3,'0') nr_versao_ptu
from	interface
where	cd_interface in (3084, 3085);
