-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE recebe_nota_rps_nfe_trat ( cd_estabelecimento_p bigint, nr_nota_fiscal_p bigint, cd_serie_nf_p text, cd_cpf_cnpj_prest_p text, dt_emissao_p text, nr_nfe_imp_p text, ds_observacao_p text, nr_seq_lote_p bigint, ie_situacao_p text default '', cd_interface_p bigint DEFAULT NULL) AS $body$
DECLARE


nr_sequencia_w	bigint;
cd_serie_nr_w	varchar(5);
dt_emissao_w	varchar(20);
cd_interface_w	interface.cd_interface%type;


BEGIN

/*conversao de formato de data	Criada por RKORZ*/

begin

dt_emissao_w	:= dt_emissao_p;

end;

begin

select	coalesce(max(replace(pls_elimina_zeros_esquerda(cd_serie_nf_p),' ','')),'X')
into STRICT	cd_serie_nr_w
;

select	coalesce(cd_interface_p,0)
into STRICT	cd_interface_w
;

SELECT	coalesce(MAX(nr_sequencia),0)
into STRICT 	nr_Sequencia_w
FROM	nota_fiscal
WHERE	cd_estabelecimento	= cd_estabelecimento_p
AND	nr_nota_fiscal		= (nr_nota_fiscal_p)::numeric
AND (cd_serie_nf		= pls_elimina_zeros_esquerda(cd_serie_nf_p) OR pls_elimina_zeros_esquerda(cd_serie_nr_w) = 'X')
AND	cd_cgc_emitente		= cd_cpf_cnpj_prest_p
AND	to_date(to_char(dt_emissao, 'dd/mm/yyyy'), 'dd/mm/yyyy') <= to_date(dt_emissao_p,'dd/mm/yyyy')
AND	coalesce(nr_nfe_imp,0)	<> pls_elimina_zeros_esquerda(nr_nfe_imp_p);

if (nr_sequencia_w > 0) then

	if (ie_situacao_p = 'C') then
		begin
		update	nota_fiscal
		set	nr_nfe_imp 		= pls_elimina_zeros_esquerda(nr_nfe_imp_p),
			nr_seq_importada	= nr_seq_lote_p,
			ie_status_envio		= ie_situacao_p
		where	nr_sequencia 		= nr_sequencia_w;
		end;
	else
		begin
		if (cd_interface_w in (2252,2176)) then
			begin
			update	nota_fiscal
			set	nr_nfe_imp 		= pls_elimina_zeros_esquerda(nr_nfe_imp_p),
				nr_seq_importada	= nr_seq_lote_p,
				ie_status_envio		= 'E'
			where	nr_sequencia 		= nr_sequencia_w;
			end;
		else
			begin
			update	nota_fiscal
			set	nr_nfe_imp 		= pls_elimina_zeros_esquerda(nr_nfe_imp_p),
				nr_seq_importada	= nr_seq_lote_p
			where	nr_sequencia 		= nr_sequencia_w;
			end;
		end if;
		end;
	end if;

	update	nota_fiscal_item
	set	nr_nfe_imp 	= pls_elimina_zeros_esquerda(nr_nfe_imp_p)
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
		--substr('NF-e importada: ' || pls_elimina_zeros_esquerda(nr_nfe_imp_p) || ' ' || ds_observacao_p,1,255));
		substr(wheb_mensagem_pck.get_texto(311869, 'NR_NFE_IMP=' || pls_elimina_zeros_esquerda(nr_nfe_imp_p)) || ' ' || ds_observacao_p,1,255));
end if;


exception when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(266358,'NR_NOTA_FISCAL=' || (nr_nota_fiscal_p)::numeric  || ';' ||
							'CD_ESTABELECIMENTO=' || cd_estabelecimento_p || ';' ||
							'CD_SERIE_NF=' || pls_elimina_zeros_esquerda(cd_serie_nf_p) || ';' ||
							'DT_EMISSAO=' || dt_emissao_w || ';' ||
							'CD_CPF_CNPJ=' || cd_cpf_cnpj_prest_p || ';' ||
							'NR_NFE_IMP=' || pls_elimina_zeros_esquerda(nr_nfe_imp_p));
	--'Erro na atualização da nf: ' 	|| to_number(nr_nota_fiscal_p)		|| chr(13) || chr(10) ||
	--'Estab: '		|| cd_estabelecimento_p 	|| chr(13) || chr(10) ||
	--'Série: ' 		|| pls_elimina_zeros_esquerda(cd_serie_nf_p)		|| chr(13) || chr(10) ||
	--'Emissão: ' 		|| dt_emissao_w		|| chr(13) || chr(10) ||
	--'CNPJ: '		|| cd_cpf_cnpj_prest_p 	|| chr(13) || chr(10) ||
	--'Nr NF-e: '		|| pls_elimina_zeros_esquerda(nr_nfe_imp_p));
end;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE recebe_nota_rps_nfe_trat ( cd_estabelecimento_p bigint, nr_nota_fiscal_p bigint, cd_serie_nf_p text, cd_cpf_cnpj_prest_p text, dt_emissao_p text, nr_nfe_imp_p text, ds_observacao_p text, nr_seq_lote_p bigint, ie_situacao_p text default '', cd_interface_p bigint DEFAULT NULL) FROM PUBLIC;

