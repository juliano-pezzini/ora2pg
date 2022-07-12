-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/* ################ End phi_get_os_list               ####################### */

/* ################ Start get_ds_owner_funcao		##################### */

CREATE OR REPLACE FUNCTION phi_ordem_servico_pck.get_ds_owner_funcao (nr_seq_ordem_serv_p man_ordem_servico.nr_sequencia%type) RETURNS PESSOA_FISICA.NM_PESSOA_FISICA%TYPE AS $body$
DECLARE

	
	cd_funcao_w		funcao.cd_funcao%type;
	ds_owner_funcao_w	pessoa_fisica.nm_pessoa_fisica%type;

	
BEGIN
	
	select	max(mos.cd_funcao)
	into STRICT	cd_funcao_w
	from	man_ordem_servico mos
	where	mos.nr_sequencia = nr_seq_ordem_serv_p;
	
	select	max(obter_nome_pf(gw.cd_responsavel)) "RnD Manager"
	into STRICT	ds_owner_funcao_w
	FROM gerencia_wheb gw, grupo_desenvolvimento gd, funcao fu, funcao_grupo_des fgd
LEFT OUTER JOIN funcao_item f ON (fgd.nr_seq_func_item = f.nr_sequencia)
WHERE gd.nr_sequencia = fgd.nr_seq_grupo and gw.nr_sequencia = gd.nr_seq_gerencia and fu.cd_funcao = fgd.cd_funcao and gd.ie_situacao = 'A' and gw.ie_situacao = 'A' and fu.ie_situacao <> 'I'  and fu.cd_funcao = cd_funcao_w;
	
	return ds_owner_funcao_w;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION phi_ordem_servico_pck.get_ds_owner_funcao (nr_seq_ordem_serv_p man_ordem_servico.nr_sequencia%type) FROM PUBLIC;