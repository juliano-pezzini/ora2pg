-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nfse_atualizar_cancelamento ( dt_cancelamento_nfe_p text, nr_sequencia_p text) AS $body$
DECLARE


dt_canc_nfe_w	timestamp := clock_timestamp();
dt_cancelamento_w varchar(19);


BEGIN


if (dt_cancelamento_nfe_p IS NOT NULL AND dt_cancelamento_nfe_p::text <> '') then
	begin
	dt_cancelamento_w := substr(dt_cancelamento_nfe_p,1,19);
	dt_canc_nfe_w := replace(dt_cancelamento_w, 'T', ' ');

	exception when others then
		begin
		dt_canc_nfe_w		:= to_date(replace(dt_cancelamento_w, 'T', ' '), 'yyyy-mm-dd hh24:mi:ss');
		exception when others then
			begin
			dt_canc_nfe_w	:= to_date(replace(dt_cancelamento_w, 'T', ' '), 'dd-mm-yyyy hh24:mi:ss');
			exception when others then
			--Não foi possível converter a data de emissão enviada no arquivo:
				CALL Wheb_mensagem_pck.exibir_mensagem_abort(186114,'DT_EMISSAO_NFE=' || dt_cancelamento_w);
			end;
		end;


	end;
end if;

update	nota_fiscal
set 	dt_cancelamento_nfe	= dt_canc_nfe_w
where	nr_sequencia		= nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nfse_atualizar_cancelamento ( dt_cancelamento_nfe_p text, nr_sequencia_p text) FROM PUBLIC;
