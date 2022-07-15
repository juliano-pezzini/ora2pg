-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_registro_worklist ( nr_atendimento_p wl_worklist.nr_atendimento%type, dt_atualizacao_p wl_worklist.dt_atualizacao%type, nm_usuario_p wl_worklist.nm_usuario%type, dt_inicial_p wl_worklist.dt_inicial%type, dt_final_previsto_p wl_worklist.dt_final_previsto%type, cd_pessoa_fisica_p wl_worklist.cd_pessoa_fisica%type, nr_seq_item_p wl_worklist.nr_seq_item%type, nr_seq_item_cpoe_p cpoe_material.nr_sequencia%type default null, ie_tipo_item_cpoe_p wl_worklist.ie_tipo_item_cpoe%type default null, ie_commit_p text default 'S') AS $body$
DECLARE


nr_seq_regra_w		bigint;


BEGIN

if ((cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and nr_seq_item_p > 0) then
	select  max(a.nr_sequencia)
	into STRICT	nr_seq_regra_w
	from	wl_regra_item a,
			wl_regra_worklist b
	where	b.nr_sequencia = a.nr_seq_regra
	and   	b.nr_seq_item = nr_seq_item_p;

	insert into wl_worklist(	nr_sequencia,
			nr_atendimento,
			dt_atualizacao,
			nm_usuario,
			dt_inicial,
			dt_final_previsto,
			cd_pessoa_fisica,
			nr_seq_item,
			nr_seq_regra,
			nr_seq_item_cpoe,
			ie_tipo_item_cpoe)
	values (	nextval('wl_worklist_seq'),
			nr_atendimento_p,
			dt_atualizacao_p,
			nm_usuario_p,
			dt_inicial_p,
			dt_final_previsto_p,
			cd_pessoa_fisica_p,
			nr_seq_item_p,
			nr_seq_regra_w,
			nr_seq_item_cpoe_p,
			ie_tipo_item_cpoe_p);
end if;

if (ie_commit_p = 'S') then
	commit;
end if;
		
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_registro_worklist ( nr_atendimento_p wl_worklist.nr_atendimento%type, dt_atualizacao_p wl_worklist.dt_atualizacao%type, nm_usuario_p wl_worklist.nm_usuario%type, dt_inicial_p wl_worklist.dt_inicial%type, dt_final_previsto_p wl_worklist.dt_final_previsto%type, cd_pessoa_fisica_p wl_worklist.cd_pessoa_fisica%type, nr_seq_item_p wl_worklist.nr_seq_item%type, nr_seq_item_cpoe_p cpoe_material.nr_sequencia%type default null, ie_tipo_item_cpoe_p wl_worklist.ie_tipo_item_cpoe%type default null, ie_commit_p text default 'S') FROM PUBLIC;

