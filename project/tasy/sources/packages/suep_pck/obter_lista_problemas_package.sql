-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION suep_pck.obter_lista_problemas ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_seq_suep_p bigint, nm_usuario_p text ) RETURNS SETOF T_PROBLEMAS_ROW_DATA AS $body$
DECLARE

			 
t_problemas_row_w	t_problemas_row;

 
C01 CURSOR FOR 
	SELECT a.cd_ciap, 
	    a.cd_doenca, 
	    a.nr_sequencia, 
	    substr(a.ds_problema,1,400) ds_problema, 
	    a.ie_status, 
	    substr(obter_desc_ciap(a.cd_ciap),1,300) ds_ciap, 
	    (SELECT substr(x.ds_doenca_cid,1,400) from cid_doenca x where x.cd_doenca_cid = a.cd_doenca) ds_doenca, 
	    a.ie_intensidade, 
        '' ds_status, 
        '' ds_intensidade, 
        a.dt_inicio, 
        a.dt_liberacao 
	from lista_problema_pac a 
	where a.cd_pessoa_fisica = cd_pessoa_fisica_p 
	and  (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') 
	and  coalesce(a.dt_fim::text, '') = '' 
	and  coalesce(a.ie_situacao,'I') = 'A' 
	order by a.dt_inicio, 
		a.ie_intensidade asc;
	
BEGIN 
 
 
for r_c01 in c01 loop 
	begin 
	t_problemas_row_w.cd_ciap		:= r_c01.cd_ciap;
	t_problemas_row_w.cd_doenca		:= r_c01.cd_doenca;
	t_problemas_row_w.nr_sequencia		:= r_c01.nr_sequencia;
	t_problemas_row_w.ds_problema		:= r_c01.ds_problema;
	t_problemas_row_w.ie_status		:= r_c01.ie_status;
	t_problemas_row_w.ds_ciap		:= r_c01.ds_ciap;
	t_problemas_row_w.ds_doenca		:= r_c01.ds_doenca;
	t_problemas_row_w.ie_intensidade	:= r_c01.ie_intensidade;	
	t_problemas_row_w.ds_status		:= r_c01.ds_status;
	t_problemas_row_w.ds_intensidade	:= r_c01.ds_intensidade;
	t_problemas_row_w.dt_inicio		:= r_c01.dt_inicio;
	t_problemas_row_w.dt_liberacao		:= r_c01.dt_liberacao;
	RETURN NEXT t_problemas_row_w;
	end;
end loop;
 
return;
 
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION suep_pck.obter_lista_problemas ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_seq_suep_p bigint, nm_usuario_p text ) FROM PUBLIC;