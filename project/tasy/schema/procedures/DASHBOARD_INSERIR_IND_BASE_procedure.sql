-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dashboard_inserir_ind_base ( ds_indicador_p text, nm_usuario_p text, ds_origem_inf_p text, nr_sequencia_p INOUT ind_base.nr_sequencia%type) AS $body$
BEGIN

	select	nextval('ind_base_seq')
	into STRICT	nr_sequencia_p
	;

	insert	into ind_base(nr_sequencia,
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		ds_indicador, 
		nr_seq_ordem_serv, 
		ie_padrao_sistema, 
		ds_sql_where, 
		ds_origem_inf, 
		cd_exp_indicador, 
		ds_objetivo, 
		ie_situacao,
		ie_origem)
	values (nr_sequencia_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		ds_indicador_p, 
		null, 
		'N', 
		null, 
		ds_origem_inf_p, 
		null, 
		null, 
		'A',
		'P');

	commit;					
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dashboard_inserir_ind_base ( ds_indicador_p text, nm_usuario_p text, ds_origem_inf_p text, nr_sequencia_p INOUT ind_base.nr_sequencia%type) FROM PUBLIC;
