-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE altera_codigo_retencao ( ie_opcao_p text, cd_retencao_p text, cd_tributo_p bigint, nr_sequencia_p bigint, dt_vencimento_p timestamp) AS $body$
BEGIN

if (ie_opcao_p = 'T') then
	begin
	if (cd_retencao_p IS NOT NULL AND cd_retencao_p::text <> '') and (cd_tributo_p IS NOT NULL AND cd_tributo_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
		begin

		update	nota_fiscal_trib
		set	cd_darf		= cd_retencao_p
		where	cd_tributo	= cd_tributo_p
		and	nr_sequencia	= nr_sequencia_p;

		end;
	end if;
	end;
elsif (ie_opcao_p = 'V') then
	begin
	if (cd_retencao_p IS NOT NULL AND cd_retencao_p::text <> '') and (cd_tributo_p IS NOT NULL AND cd_tributo_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (dt_vencimento_p IS NOT NULL AND dt_vencimento_p::text <> '') then
		begin

		update	nota_fiscal_venc_trib
		set	cd_darf		= cd_retencao_p
		where	cd_tributo	= cd_tributo_p
		and	nr_sequencia	= nr_sequencia_p
		and	dt_vencimento	= dt_vencimento_p;

		end;
	end if;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE altera_codigo_retencao ( ie_opcao_p text, cd_retencao_p text, cd_tributo_p bigint, nr_sequencia_p bigint, dt_vencimento_p timestamp) FROM PUBLIC;

