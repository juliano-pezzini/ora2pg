-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_dados_nfse_gerada ( nm_usuario_p text, cd_verificacao_nfse_p text, nr_nota_fiscal_p text, nr_nfse_p text, cd_estabelecimento_p bigint, cd_serie_nf_p text, cd_cpf_cnpj_prest_p text, dt_emissao_nfe_p text ) AS $body$
DECLARE



nr_sequencia_w		bigint;
dt_emissao_nfe_aux_w	varchar(50);
dt_emissao_nfe_w 	timestamp;


BEGIN

if (dt_emissao_nfe_p IS NOT NULL AND dt_emissao_nfe_p::text <> '') then
	begin
	dt_emissao_nfe_aux_w := dt_emissao_nfe_p;
	dt_emissao_nfe_w     := replace(dt_emissao_nfe_aux_w, 'T', ' ');

	exception when others then
		begin

		if (length(trim(both dt_emissao_nfe_aux_w)) > 19) then
			begin
			dt_emissao_nfe_aux_w := substr(dt_emissao_nfe_aux_w,1,19);
			end;
		end if;

		dt_emissao_nfe_w		:= to_date(replace(dt_emissao_nfe_aux_w, 'T', ' '), 'yyyy-mm-dd hh24:mi:ss');
		exception when others then
			begin
			dt_emissao_nfe_w	:= to_date(replace(dt_emissao_nfe_aux_w, 'T', ' '), 'dd-mm-yyyy hh24:mi:ss');
			exception when others then
			--'Não foi possível converter a data de emissão enviada no arquivo: ' + dt_emissao_nfe_p;
				CALL wheb_mensagem_pck.exibir_mensagem_abort(265333,'DT_EMISSAO=' || dt_emissao_nfe_p);
			end;
		end;


	end;
end if;

/* OS 365130
if (dt_emissao_nfe_p is not null) then

dt_emissao_nfe_w := TO_DATE(SUBSTR(dt_emissao_nfe_p,9,2) || '/' || SUBSTR(dt_emissao_nfe_p,6,2) || '/' || SUBSTR(dt_emissao_nfe_p,1,4) || ' ' || SUBSTR(dt_emissao_nfe_p,12,8), 'dd/mm/yyyy hh:mi:ss');

end if;
*/
select	coalesce(max(nr_sequencia), 0)
into STRICT	nr_sequencia_w
from	nota_fiscal
where	cd_estabelecimento	= cd_estabelecimento_p
and	nr_nota_fiscal		= nr_nota_fiscal_p
and	cd_serie_nf		= cd_serie_nf_p
and	cd_cgc_emitente		= cd_cpf_cnpj_prest_p
and	coalesce(nr_nfe_imp, 0) <> nr_nfse_p;

if (nr_sequencia_w > 0) then

	update	nota_fiscal
	set	nr_nfe_imp 		= nr_nfse_p,
		cd_verificacao_nfse	= cd_verificacao_nfse_p,
		dt_emissao_nfe		= dt_emissao_nfe_w
	where	nr_sequencia 		= nr_sequencia_w;

	update	nota_fiscal_item
	set	nr_nfe_imp 	= nr_nfse_p
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
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_sequencia_w,
		'27',
		'NFS-e: ' || nr_nfse_p);

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_dados_nfse_gerada ( nm_usuario_p text, cd_verificacao_nfse_p text, nr_nota_fiscal_p text, nr_nfse_p text, cd_estabelecimento_p bigint, cd_serie_nf_p text, cd_cpf_cnpj_prest_p text, dt_emissao_nfe_p text ) FROM PUBLIC;

