-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS nota_fiscal_atual ON nota_fiscal CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_nota_fiscal_atual() RETURNS trigger AS $BODY$
declare

qt_existe_w			bigint;
ie_tipo_ordem_w		ordem_compra.ie_tipo_ordem%type;
count_w				bigint;
reg_integracao_p	gerar_int_padrao.reg_integracao;

BEGIN


if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;


if (TG_OP = 'UPDATE') then
BEGIN

select	count(*)
into STRICT	qt_existe_w
from	sup_parametro_integracao
where	cd_estabelecimento = NEW.cd_estabelecimento
and	ie_evento = 'NF'
and	ie_forma = 'E'
and	ie_situacao = 'A';

if (TG_OP = 'UPDATE') then
	if (NEW.cd_cgc_emitente <> OLD.cd_cgc_emitente) and (NEW.nr_ordem_compra is not null) then
		BEGIN
		
		select	coalesce(ie_tipo_ordem,'N')
		into STRICT	ie_tipo_ordem_w
		from	ordem_compra
		where	nr_ordem_compra = NEW.nr_ordem_compra;
		
		if (ie_tipo_ordem_w = 'T') then
			BEGIN
			CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(358504);
			end;
		end if;
		
		end;
	end if;

end if;

if (qt_existe_w > 0) and (NEW.ie_tipo_nota in ('SD','SE','SF')) and (OLD.dt_atualizacao_estoque is null) and (NEW.dt_atualizacao_Estoque is not null) then

	CALL envio_sup_int_nf(
		NEW.nr_sequencia,
		NEW.ie_tipo_nota,
		NEW.cd_estabelecimento,
		NEW.nr_nota_fiscal,
		NEW.dt_emissao,
		NEW.cd_cgc_emitente,
		NEW.cd_cgc,
		NEW.cd_pessoa_fisica,
		NEW.cd_serie_nf,
		NEW.cd_natureza_operacao,
		NEW.cd_condicao_pagamento,
		NEW.cd_operacao_nf,
		NEW.vl_seguro,
		NEW.vl_despesa_acessoria,
		NEW.vl_frete,
		NEW.ds_observacao,
		NEW.nm_usuario);
end if;


if (NEW.ie_situacao = '1') and (NEW.dt_atualizacao_estoque is not null) and (OLD.nr_nfe_imp is null) and (NEW.nr_nfe_imp is not null) then

reg_integracao_p.ie_operacao	:=	'I';
reg_integracao_p.cd_operacao_nf :=  NEW.cd_operacao_nf;
reg_integracao_p.cd_natureza_operacao := NEW.cd_natureza_operacao;
reg_integracao_p.cd_estabelecimento := NEW.cd_estabelecimento;

reg_integracao_p := gerar_int_padrao.gravar_integracao('433', NEW.nr_sequencia, 'TASY', reg_integracao_p);

end if;

end;
end if;


if (NEW.ie_situacao <> OLD.ie_situacao) then
	CALL gerar_historico_nota_fiscal(	NEW.nr_sequencia,
					NEW.nm_usuario,
					'20',
					obter_expressao_idioma(306502) || ' ' || obter_expressao_idioma(621064) || OLD.ie_situacao || ' ' || obter_expressao_idioma(621043) || ' ' || NEW.ie_situacao);
end if;



<<Final>>
count_w	:= 0;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_nota_fiscal_atual() FROM PUBLIC;

CREATE TRIGGER nota_fiscal_atual
	BEFORE UPDATE ON nota_fiscal FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_nota_fiscal_atual();

