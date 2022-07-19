-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verificar_anestesista_js ( nr_acao_executada_p bigint, nr_seq_escala_diaria_p bigint, cd_pessoa_fisica_p bigint, nr_seq_escala_p bigint, dt_escala_p timestamp, ds_erro_p INOUT text, qt_anestesista_p INOUT bigint, ds_consistencia_p INOUT text) AS $body$
DECLARE

 
qt_anestesista_w	bigint;
ds_erro_w	varchar(50);
ds_consistencia_w	varchar(255);


BEGIN 
 
if (nr_seq_escala_diaria_p IS NOT NULL AND nr_seq_escala_diaria_p::text <> '')and (nr_acao_executada_p = 1)then 
	begin 
	 
	select 	count(*) 
	into STRICT	qt_anestesista_w 
	from 	escala_diaria_adic 
	where 	nr_seq_escala_diaria 	= nr_seq_escala_diaria_p 
	and 	cd_pessoa_fisica 	= cd_pessoa_fisica_p;
	 
	ds_erro_w		:= obter_texto_tasy(47049, 1);
	 
	end;
end if;
 
ds_consistencia_w	:= obter_se_prof_liberado_escala(cd_pessoa_fisica_p, nr_seq_escala_p, dt_escala_p);
ds_erro_p		:= ds_erro_w;
qt_anestesista_p	:= qt_anestesista_w;
ds_consistencia_p	:= ds_consistencia_w;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verificar_anestesista_js ( nr_acao_executada_p bigint, nr_seq_escala_diaria_p bigint, cd_pessoa_fisica_p bigint, nr_seq_escala_p bigint, dt_escala_p timestamp, ds_erro_p INOUT text, qt_anestesista_p INOUT bigint, ds_consistencia_p INOUT text) FROM PUBLIC;

