-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_gerencia_envio_ans_pck.obter_desp_proc_pacote ( cd_procedimento_p pls_monitor_tiss_proc.cd_procedimento%type, ie_origem_proced_p pls_monitor_tiss_proc.ie_origem_proced%type, nr_seq_material_p pls_material.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE

ie_classificacao_w	procedimento.ie_classificacao%type;


BEGIN
	if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') and (ie_origem_proced_p IS NOT NULL AND ie_origem_proced_p::text <> '') then
		select	ie_classificacao
		into STRICT	ie_classificacao_w
		from	procedimento
		where	cd_procedimento	= cd_procedimento_p
		and	ie_origem_proced = ie_origem_proced_p;
	else
		select	ie_tipo_despesa
		into STRICT	ie_classificacao_w
		from	pls_material
		where	nr_sequencia = nr_seq_material_p;
	end if;

return ie_classificacao_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_gerencia_envio_ans_pck.obter_desp_proc_pacote ( cd_procedimento_p pls_monitor_tiss_proc.cd_procedimento%type, ie_origem_proced_p pls_monitor_tiss_proc.ie_origem_proced%type, nr_seq_material_p pls_material.nr_sequencia%type) FROM PUBLIC;
