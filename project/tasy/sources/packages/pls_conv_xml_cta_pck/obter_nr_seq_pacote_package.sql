-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_conv_xml_cta_pck.obter_nr_seq_pacote ( nr_seq_item_p pls_conta_item_imp.nr_sequencia%type, cd_procedimento_conv_p pls_conta_item_imp.cd_procedimento_conv%type, ie_origem_proced_conv_p pls_conta_item_imp.ie_origem_proced_conv%type, nm_usuario_p usuario.nm_usuario%type) RETURNS bigint AS $body$
DECLARE


nr_seq_pacote_conv_w	pls_conta_item_imp.nr_seq_pacote_conv%type;
ie_regra_preco_w	pls_pacote.ie_regra_preco%type;
nr_seq_regra_preco_w	pls_pacote_tipo_acomodacao.nr_sequencia%type;


BEGIN

-- precisa do procedimento para tentar encontrar um pacote, caso n_o seja passado nem _ feita a verificacao

if (cd_procedimento_conv_p IS NOT NULL AND cd_procedimento_conv_p::text <> '') then
	
	-- tenta primeiro encontrar com procedimento, origem 

	select	max(nr_sequencia),
		max(ie_regra_preco)
	into STRICT	nr_seq_pacote_conv_w,
		ie_regra_preco_w
	from	pls_pacote
	where	cd_procedimento = cd_procedimento_conv_p
	and	ie_origem_proced = ie_origem_proced_conv_p
	and	ie_situacao = 'A';

	-- se n_o encontrou tenta s_ pelo cd_procedimento

	if (coalesce(nr_seq_pacote_conv_w::text, '') = '') then
	
		select	max(nr_sequencia),
			max(ie_regra_preco)
		into STRICT	nr_seq_pacote_conv_w,
			ie_regra_preco_w
		from	pls_pacote
		where	cd_procedimento	= cd_procedimento_conv_p
		and	ie_situacao = 'A';
	end if;
end if;

if (ie_regra_preco_w = 'S') then
	
	pls_obter_regra_preco_pacote(	cd_procedimento_conv_p,
					ie_origem_proced_conv_p,
					'PI',
					nr_seq_item_p,
					nm_usuario_p,
					nr_seq_pacote_conv_w,
					nr_seq_regra_preco_w);
end if;

return	nr_seq_pacote_conv_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_conv_xml_cta_pck.obter_nr_seq_pacote ( nr_seq_item_p pls_conta_item_imp.nr_sequencia%type, cd_procedimento_conv_p pls_conta_item_imp.cd_procedimento_conv%type, ie_origem_proced_conv_p pls_conta_item_imp.ie_origem_proced_conv%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
