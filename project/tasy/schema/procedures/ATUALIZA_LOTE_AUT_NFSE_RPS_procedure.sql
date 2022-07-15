-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_lote_aut_nfse_rps ( nr_seq_transmissao_p bigint, nr_nfe_imp_p text, cd_verificacao_nfse_p text, dt_emissao_nfe_p text, cd_serie_nf_p text, nr_rps_sequencial_p text, cd_cgc_emitente_p text, dt_emissao_rps_p text) AS $body$
DECLARE



dt_emissao_nfe_aux_w	varchar(50);
dt_emissao_nfe_w		timestamp;
ie_situacao_w			varchar(1);
dt_emissao_rps_w		timestamp;
cd_interno_w			nota_fiscal.cd_serie_nf%type;
nr_sequencia_w			bigint;
nr_rps_sequencial_w		nota_fiscal.nr_rps_sequencial%type;



BEGIN

select	max(b.nr_sequencia)
into STRICT	nr_sequencia_w
from	nfe_transmissao_nf a,
		nota_fiscal b
where	a.nr_seq_transmissao = nr_seq_transmissao_p
and		a.nr_rps_sequencial  = nr_rps_sequencial_p
and		b.nr_sequencia 		 = a.nr_seq_nota_fiscal
and		b.cd_serie_nf		 = cd_serie_nf_p;

nr_rps_sequencial_w := nr_rps_sequencial_p;

--Encontrou a nota
if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
	begin

	if (dt_emissao_rps_p <> 'X') then
		begin
		dt_emissao_rps_w := replace(dt_emissao_rps_p, 'T', ' ');

		exception when others then
			begin
			dt_emissao_rps_w		:= to_date(replace(dt_emissao_rps_p, 'T', ' '), 'yyyy-mm-dd hh24:mi:ss');
			exception when others then
				begin
				dt_emissao_rps_w	:= to_date(replace(dt_emissao_rps_p, 'T', ' '), 'dd-mm-yyyy hh24:mi:ss');
				exception when others then
				--Não foi possível converter a data de emissão enviada no arquivo:
					CALL Wheb_mensagem_pck.exibir_mensagem_abort(186114,'DT_EMISSAO_NFE=' || dt_emissao_rps_p);
				end;
			end;
		end;
	end if;

	cd_interno_w	:= substr(obter_conversao_interna(cd_cgc_emitente_p,'NOTA_FISCAL','CD_SERIE_NF',coalesce(trim(both cd_serie_nf_p),0)),1,40);

	if (coalesce(cd_interno_w::text, '') = '') then
		begin

		select	ie_situacao
		into STRICT	ie_situacao_w
		from 	nota_fiscal
		where 	nr_sequencia  = nr_sequencia_w
		and		cd_serie_nf	= cd_serie_nf_p
		and 	ie_tipo_nota in ('SE','SD','SF','ST')
		and	((to_char(dt_emissao,'dd/mm/yyyy') 	= to_char(dt_emissao_rps_w,'dd/mm/yyyy')) or (dt_emissao_rps_p = 'X'))
		and	((cd_cgc_emitente	= cd_cgc_emitente_p) or (cd_cgc_emitente_p = 'X'))
		and	not ie_situacao in ('2','3');

		end;
	else
		begin

		select	ie_situacao
		into STRICT	ie_situacao_w
		from 	nota_fiscal
		where 	nr_sequencia  	= nr_sequencia_w
		and	cd_serie_nf		= trim(both cd_interno_w)
		and 	ie_tipo_nota in ('SE','SD','SF','ST')
		and	((to_char(dt_emissao,'dd/mm/yyyy') 	= to_char(dt_emissao_rps_w,'dd/mm/yyyy')) or (dt_emissao_rps_p = 'X'))
		and	((cd_cgc_emitente	= cd_cgc_emitente_p) or (cd_cgc_emitente_p = 'X'))
		and	not ie_situacao in ('2','3');

		end;
	end if;

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
				--Não foi possível converter a data de emissão enviada no arquivo:
					CALL Wheb_mensagem_pck.exibir_mensagem_abort(186114,'DT_EMISSAO_NFE=' || dt_emissao_nfe_aux_w);
				end;
			end;


		end;
	end if;


	if (ie_situacao_w <> '8') then

		if (coalesce(cd_interno_w::text, '') = '') then
			begin

			update	nota_fiscal
			set 	nr_nfe_imp		= nr_nfe_imp_p,
				cd_verificacao_nfse 	= cd_verificacao_nfse_p,
				nr_rps_sequencial	= nr_rps_sequencial_w,
				dt_emissao_nfe		= dt_emissao_nfe_w
			where	nr_sequencia		= nr_sequencia_w
			and	cd_serie_nf		= cd_serie_nf_p
			and 	ie_tipo_nota in ('SE','SD','SF','ST')
			and	((cd_cgc_emitente	= cd_cgc_emitente_p) or (cd_cgc_emitente_p = 'X'))
			and	ie_situacao in ('1')
			and	((to_char(dt_emissao,'dd/mm/yyyy') 	= to_char(dt_emissao_rps_w,'dd/mm/yyyy')) or (dt_emissao_rps_p = 'X'));

			end;
		else
			begin

			update	nota_fiscal
			set 	nr_nfe_imp		=  nr_nfe_imp_p,
				cd_verificacao_nfse 	= cd_verificacao_nfse_p,
				nr_rps_sequencial	= nr_rps_sequencial_w,
				dt_emissao_nfe		= dt_emissao_nfe_w
			where	nr_sequencia		= nr_sequencia_w
			and	cd_serie_nf		= trim(both cd_interno_w)
			and 	ie_tipo_nota in ('SE','SD','SF','ST')
			and	((cd_cgc_emitente	= cd_cgc_emitente_p) or (cd_cgc_emitente_p = 'X'))
			and	ie_situacao in ('1')
			and	((to_char(dt_emissao,'dd/mm/yyyy') 	= to_char(dt_emissao_rps_w,'dd/mm/yyyy')) or (dt_emissao_rps_p = 'X'));

			end;
		end if;

	else

		if (coalesce(cd_interno_w::text, '') = '') then
			begin

			update	nota_fiscal
			set 	nr_nfe_imp		= nr_nfe_imp_p,
				cd_verificacao_nfse 	= cd_verificacao_nfse_p,
				nr_rps_sequencial	= nr_rps_sequencial_w,
				dt_emissao_nfe		= dt_emissao_nfe_w,
				dt_atualizacao_estoque	= clock_timestamp(),
				ie_situacao		= '1'
			where	nr_sequencia		= nr_sequencia_w
			and	cd_serie_nf		= cd_serie_nf_p
			and 	ie_tipo_nota in ('SE','SD','SF','ST')
			and	((cd_cgc_emitente	= cd_cgc_emitente_p) or (cd_cgc_emitente_p = 'X'))
			and	((to_char(dt_emissao,'dd/mm/yyyy') 	= to_char(dt_emissao_rps_w,'dd/mm/yyyy')) or (dt_emissao_rps_p = 'X'));

			end;
		else
			begin

			update	nota_fiscal
			set 	nr_nfe_imp		= nr_nfe_imp_p,
				cd_verificacao_nfse 	= cd_verificacao_nfse_p,
				nr_rps_sequencial	= nr_rps_sequencial_w,
				dt_emissao_nfe		= dt_emissao_nfe_w,
				dt_atualizacao_estoque	= clock_timestamp(),
				ie_situacao		= '1'
			where	nr_sequencia		= nr_sequencia_w
			and	cd_serie_nf		= trim(both cd_interno_w)
			and 	ie_tipo_nota in ('SE','SD','SF','ST')
			and	((cd_cgc_emitente	= cd_cgc_emitente_p) or (cd_cgc_emitente_p = 'X'))
			and	((to_char(dt_emissao,'dd/mm/yyyy') 	= to_char(dt_emissao_rps_w,'dd/mm/yyyy')) or (dt_emissao_rps_p = 'X'));

			end;
		end if;

	end if;

	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_lote_aut_nfse_rps ( nr_seq_transmissao_p bigint, nr_nfe_imp_p text, cd_verificacao_nfse_p text, dt_emissao_nfe_p text, cd_serie_nf_p text, nr_rps_sequencial_p text, cd_cgc_emitente_p text, dt_emissao_rps_p text) FROM PUBLIC;

