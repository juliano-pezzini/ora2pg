-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE deleta_dados_filha ( nm_usuario_p text, nr_seq_etapa_p bigint) AS $body$
BEGIN

delete from w_proj_filtro_etapa where nm_usuario = nm_usuario_p;

insert into w_proj_filtro_etapa values (clock_timestamp(),nm_usuario_p,nr_seq_etapa_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE deleta_dados_filha ( nm_usuario_p text, nr_seq_etapa_p bigint) FROM PUBLIC;

