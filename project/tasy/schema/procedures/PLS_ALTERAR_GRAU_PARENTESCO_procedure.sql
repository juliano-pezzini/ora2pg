-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_grau_parentesco ( nr_seq_segurado_p bigint, nr_seq_parentesco_p bigint, dt_geracao_sib_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_contrato_w		pls_contrato.nr_sequencia%type;
nr_seq_parentesco_ant_w		bigint;
qt_registros_w			bigint;
ds_historico_w			varchar(255);
ie_altera_cart_idenficacao_w	varchar(10);
ie_tipo_parentesco_w		grau_parentesco.ie_tipo_parentesco%type;
nr_seq_vinculo_sca_w		pls_sca_vinculo.nr_sequencia%type;
nm_beneficiario_w		varchar(255);
qt_idade_w			bigint;
ie_estado_civil_w		pessoa_fisica.ie_estado_civil%type;
ie_titularidade_w		varchar(10);

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_sca_vinculo
	where	nr_seq_segurado = nr_seq_segurado_p;


BEGIN

ie_altera_cart_idenficacao_w	:= coalesce(obter_valor_param_usuario(1202, 96, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p), 'N');

--Utilizada a procedure na funcao OPS - Gestao de Contratos e OPS -Contratos de Intercambio
select	max(nr_seq_contrato),
	max(nr_seq_parentesco),
	max(b.nm_pessoa_fisica),
	max(b.ie_estado_civil),
	CASE WHEN coalesce(max(a.nr_seq_titular)::text, '') = '' THEN 'T'  ELSE 'D' END
into STRICT	nr_seq_contrato_w,
	nr_seq_parentesco_ant_w,
	nm_beneficiario_w,
	ie_estado_civil_w,
	ie_titularidade_w
from	pls_segurado a,
	pessoa_fisica b
where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
and	a.nr_sequencia	= nr_seq_segurado_p;

select	max(ie_tipo_parentesco)
into STRICT	ie_tipo_parentesco_w
from	grau_parentesco
where	nr_sequencia	= nr_seq_parentesco_p;

qt_idade_w := pls_obter_idade_segurado(nr_seq_segurado_p,dt_geracao_sib_p,'A');

select	count(1)
into STRICT	qt_registros_w
from	pls_restricao_inclusao_seg
where	nr_seq_contrato	= nr_seq_contrato_w
and	dt_geracao_sib_p between trunc(coalesce(dt_inicio_vigencia,dt_geracao_sib_p),'dd') and fim_dia(coalesce(dt_fim_vigencia,dt_geracao_sib_p))
and	((ie_titularidade	= ie_titularidade_w) or (ie_titularidade = 'A'))
and (qt_idade_w  between coalesce(qt_idade_inicial,qt_idade_w) and coalesce(qt_idade_final,qt_idade_w))
and (nr_seq_parentesco = nr_seq_parentesco_p or coalesce(nr_seq_parentesco::text, '') = '')
and (ie_estado_civil = ie_estado_civil_w or coalesce(ie_estado_civil::text, '') = '');

if (qt_registros_w	> 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1109746, 'NM_BENEFICIARIO=' || nm_beneficiario_w);
	--Mensagem: O grau de parentesco nao pode ser alterado para o beneficiario #@NM_BENEFICIARIO#@. Favor verificar as regras de restricoes de inclusao do contrato;
end if;

ds_historico_w	:= wheb_mensagem_pck.get_texto(1109747, 'DS_PARENTESCO_ANT=' || substr(Obter_desc_parentesco(nr_seq_parentesco_ant_w),1,50) || ';DS_PARENTESCO=' ||
			substr(Obter_desc_parentesco(nr_seq_parentesco_p),1,50));

update 	pls_segurado
set 	nr_seq_parentesco	= nr_seq_parentesco_p
where	nr_sequencia		= nr_seq_segurado_p;

CALL pls_alterar_tp_parentesco(nr_seq_segurado_p,ie_tipo_parentesco_w,nm_usuario_p);

-- Gerar historico
CALL pls_gerar_segurado_historico(
	nr_seq_segurado_p, '20', clock_timestamp(),
	ds_historico_w,'pls_alterar_grau_parentesco', null,
	null, null, null,
	dt_geracao_sib_p, null, null,
	null, nr_seq_parentesco_ant_w, null,
	null, nm_usuario_p, 'S');

if (nr_seq_contrato_w > 0) then
	CALL pls_preco_beneficiario_pck.atualizar_desconto_benef(nr_seq_contrato_w, clock_timestamp(), null, 'N', nm_usuario_p, cd_estabelecimento_p);

	if (ie_altera_cart_idenficacao_w = 'S') then
		CALL pls_alterar_cartao_ident_benef(nr_seq_segurado_p,dt_geracao_sib_p,cd_estabelecimento_p,nm_usuario_p);
	end if;
end if;

open C01;
loop
fetch C01 into
	nr_seq_vinculo_sca_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	CALL pls_gerar_valor_tabela_sca(nr_seq_segurado_p, nr_seq_vinculo_sca_w, 'T', dt_geracao_sib_p, nm_usuario_p, cd_estabelecimento_p);
	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_grau_parentesco ( nr_seq_segurado_p bigint, nr_seq_parentesco_p bigint, dt_geracao_sib_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

