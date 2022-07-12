-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Obtem o outorgante pelo c_digo ans



CREATE OR REPLACE FUNCTION pls_conv_xml_cta_pck.obter_outorgante_conv ( cd_ans_p pls_protocolo_conta_imp.cd_ans%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) RETURNS bigint AS $body$
DECLARE


nr_seq_outorgante_conv_w	pls_protocolo_conta_imp.nr_seq_outorgante_conv%type;


BEGIN

-- Verifica se existe um outorgante para o estabelecimento e c_digo ANS informados

select	max(nr_sequencia)
into STRICT	nr_seq_outorgante_conv_w
from	pls_outorgante
where	cd_ans = cd_ans_p
and	cd_estabelecimento = cd_estabelecimento_p;

-- se n_o existir outorgante no estabelecimento que vem do protocolo busca a outorgante sem o estabelecimento

if (coalesce(nr_seq_outorgante_conv_w::text, '') = '') then

	select	max(nr_sequencia)
	into STRICT	nr_seq_outorgante_conv_w
	from	pls_outorgante
	where	cd_ans = cd_ans_p;
end if;

return	nr_seq_outorgante_conv_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_conv_xml_cta_pck.obter_outorgante_conv ( cd_ans_p pls_protocolo_conta_imp.cd_ans%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
