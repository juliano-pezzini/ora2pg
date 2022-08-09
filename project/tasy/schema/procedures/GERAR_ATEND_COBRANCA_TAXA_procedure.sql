-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_atend_cobranca_taxa ( nr_atendimento_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		atend_cobranca_taxa.nr_sequencia%type;


BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	begin
	if (ie_opcao_p = 'I') then
		begin

		insert into atend_cobranca_taxa(
			nr_sequencia,
			nr_atendimento,
			nm_usuario_inicio,
			dt_inicio_cobranca,
			nm_usuario_fim,
			dt_fim_cobranca)
		values (nextval('regra_cobranca_taxa_seq'),
			nr_atendimento_p,
			nm_usuario_p,
			clock_timestamp(),
			null,
			null);

		end;
	elsif (ie_opcao_p = 'F') then
		begin

		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_sequencia_w
		from	atend_cobranca_taxa
		where	nr_atendimento = nr_atendimento_p
		and	coalesce(dt_fim_cobranca::text, '') = '';

		update	atend_cobranca_taxa
		set	nm_usuario_fim = nm_usuario_p,
			dt_fim_cobranca = clock_timestamp()
		where	nr_sequencia = nr_sequencia_w;

		end;
	end if;
	end;
end if;
if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_atend_cobranca_taxa ( nr_atendimento_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;
