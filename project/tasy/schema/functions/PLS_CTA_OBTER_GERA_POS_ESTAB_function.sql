-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_cta_obter_gera_pos_estab ( nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_intercambio_p pls_intercambio.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Verificar se deve ser gerado valor de pós-estabelecido para beneficiários deste contrato
	conforme a regra de geração do pós-estabelecido do contrato.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

Alterações:
-------------------------------------------------------------------------------------------------------------------
jjung OS 657581 30/10/2013 - Criação da function.
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_gerar_w	varchar(1);

-- Obter as regras que são
cs_regras_contrato CURSOR(	nr_seq_contrato_pc	pls_contrato.nr_sequencia%type) FOR
	SELECT	coalesce(a.ie_gera_pos_estabelecido, 'N') ie_gera_pos_estabelecido
	from	pls_ger_pos_estabelecido a
	where	a.nr_seq_contrato = nr_seq_contrato_pc
	-- passar para quem não gera no final
	order by coalesce(a.ie_gera_pos_estabelecido, 'N') desc;

cs_regras_intercambio CURSOR(	nr_seq_intercambio_pc	pls_intercambio.nr_sequencia%type) FOR
	SELECT	coalesce(a.ie_gera_pos_estabelecido, 'N') ie_gera_pos_estabelecido
	from	pls_ger_pos_estabelecido a
	where	a.nr_seq_intercambio = nr_seq_intercambio_pc
	-- passar para quem não gera no final
	order by coalesce(a.ie_gera_pos_estabelecido, 'N') desc;
BEGIN

-- Por default, se não tiver regra continua gerando normal.
ie_gerar_w := 'S';

-- Quando o contrato for informado
if (nr_seq_contrato_p IS NOT NULL AND nr_seq_contrato_p::text <> '') then

	-- Varrer as regras de geração do pós estabelecido e verificar se irá gerar ou não.
	for	rw_cs_regras_contrato_w in cs_regras_contrato(nr_seq_contrato_p) loop

		ie_gerar_w := rw_cs_regras_contrato_w.ie_gera_pos_estabelecido;
	end loop;
-- Quando for contrato de intercambio.
elsif (nr_seq_intercambio_p IS NOT NULL AND nr_seq_intercambio_p::text <> '') then

	-- Varrer as regras de geração do pós estabelecido e verificar se irá gerar ou não.
	for	rw_cs_regras_intercambio_w in cs_regras_intercambio(nr_seq_intercambio_p) loop

		ie_gerar_w := rw_cs_regras_intercambio_w.ie_gera_pos_estabelecido;
	end loop;
end if;

return	ie_gerar_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_cta_obter_gera_pos_estab ( nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_intercambio_p pls_intercambio.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
