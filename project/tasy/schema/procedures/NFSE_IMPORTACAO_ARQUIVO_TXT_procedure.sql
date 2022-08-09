-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nfse_importacao_arquivo_txt ( cd_estabelecimento_p bigint, nr_nota_fiscal_p bigint, cd_serie_nf_p text, cd_cpf_cnpj_prest_p text, dt_emissao_nfe_p text, nr_nfe_imp_p text, ds_observacao_p text, cd_verificacao_nfse_p text, ie_situacao_p text default '') AS $body$
DECLARE


nr_sequencia_w	bigint;
cd_serie_nr_w	varchar(5);
dt_emissao_w	timestamp;
cd_cgc_emit_w	varchar(15);


BEGIN

/*conversao de formato de data*/

begin

dt_emissao_w	:= dt_emissao_nfe_p;

exception when others then
	begin
	dt_emissao_w		:= to_date(dt_emissao_nfe_p,'yyyy-mm-dd');
	exception when others then
		begin
		dt_emissao_w	:= to_date(dt_emissao_nfe_p,'dd-mm-yyyy');
		exception when others then
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(229750,'DT_EMISSAO=' || dt_emissao_nfe_p);
		end;
	end;
end;

begin

select	cd_cgc
into STRICT	cd_cgc_emit_w
from	estabelecimento
where	cd_estabelecimento	= cd_estabelecimento_p;

select	max(replace(cd_serie_nf_p,' ',''))
into STRICT	cd_serie_nr_w
;

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_sequencia_w
from	nota_fiscal
where	cd_estabelecimento	= cd_estabelecimento_p
and	nr_nota_fiscal		= to_char(nr_nota_fiscal_p)
and	cd_serie_nf			= cd_serie_nf_p
and	cd_cgc_emitente		= coalesce(cd_cpf_cnpj_prest_p,cd_cgc_emit_w)
and	coalesce(nr_nfe_imp,0)	<> 	nr_nfe_imp_p;

if (nr_sequencia_w > 0) then

	if (ie_situacao_p = 'C') then
		update	nota_fiscal
		set	nr_nfe_imp 			= nr_nfe_imp_p,
			cd_verificacao_nfse = cd_verificacao_nfse_p,
			dt_emissao_nfe		= dt_emissao_w,
			ie_status_envio		= ie_situacao_p
		where	nr_sequencia 		= nr_sequencia_w;
	else
		update	nota_fiscal
		set	nr_nfe_imp 			= nr_nfe_imp_p,
			cd_verificacao_nfse = cd_verificacao_nfse_p,
			dt_emissao_nfe		= dt_emissao_w,
			ie_status_envio		= ie_situacao_p
		where	nr_sequencia 		= nr_sequencia_w;
	end if;
	update	nota_fiscal_item
	set	nr_nfe_imp 	= nr_nfe_imp_p
	where	nr_sequencia 	= nr_sequencia_w;

	insert into nota_fiscal_hist(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_nota,
		cd_evento,
		ds_historico)
	values (	nextval('nota_fiscal_hist_seq'),
		clock_timestamp(),
		'Tasy',
		clock_timestamp(),
		'Tasy',
		nr_sequencia_w,
		'27',
		substr(WHEB_MENSAGEM_PCK.get_texto(312266) || nr_nfe_imp_p || ' ' || ds_observacao_p,1,255)); --NF-e importada:
end if;


exception when others then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(229751,'NR_NOTA_FISCAL=' || nr_nota_fiscal_p ||';'||
												'CD_ESTABELECIMENTO=' || cd_serie_nf_p ||';'||
												'CD_SERIE_NF=' || cd_serie_nf_p ||';'||
												'DT_EMISSAO=' || dt_emissao_nfe_p ||';'||
												'CD_CNPJ_EMITENTE=' || coalesce(cd_cpf_cnpj_prest_p,cd_cgc_emit_w) ||';'||
												'NR_NFE_IMP=' || nr_nfe_imp_p );
end;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nfse_importacao_arquivo_txt ( cd_estabelecimento_p bigint, nr_nota_fiscal_p bigint, cd_serie_nf_p text, cd_cpf_cnpj_prest_p text, dt_emissao_nfe_p text, nr_nfe_imp_p text, ds_observacao_p text, cd_verificacao_nfse_p text, ie_situacao_p text default '') FROM PUBLIC;
