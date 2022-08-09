-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cons_pep_cih_precaucao ( DT_INICIO_P timestamp, nr_atendimento_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE

 
dt_entrada_w	timestamp;


BEGIN 
 
select 	dt_entrada 
into STRICT 	dt_entrada_w 
from 	ATENDIMENTO_PACIENTE a 
where 	a.nr_atendimento = nr_atendimento_p;
 
if (DT_INICIO_P	< dt_entrada_w)	then 
	ds_erro_p := obter_texto_tasy(364108, wheb_usuario_pck.get_nr_seq_idioma);
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cons_pep_cih_precaucao ( DT_INICIO_P timestamp, nr_atendimento_p bigint, ds_erro_p INOUT text) FROM PUBLIC;
