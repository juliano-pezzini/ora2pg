-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tre_altera_convenio_agenda ( nr_seq_agenda_consulta_p bigint, cd_convenio_p bigint, cd_categoria_p text, nm_paciente_p text, cd_tipo_acomodacao_p bigint, cd_usuario_convenio_p text, cd_pessoa_fisica_p text, dt_validade_carteira_p text) AS $body$
BEGIN
if (nr_seq_agenda_consulta_p IS NOT NULL AND nr_seq_agenda_consulta_p::text <> '') then
	update	agenda_consulta
	set	cd_convenio = cd_convenio_p,
		cd_categoria = cd_categoria_p,
		cd_pessoa_fisica = cd_pessoa_fisica_p,
		nm_paciente	=	nm_paciente_p,
		cd_tipo_acomodacao = cd_tipo_acomodacao_p,
		cd_usuario_convenio = cd_usuario_convenio_p,
		dt_validade_carteira = to_date(dt_validade_carteira_p,'dd/mm/yyyy')
	where	nr_sequencia = nr_seq_agenda_consulta_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tre_altera_convenio_agenda ( nr_seq_agenda_consulta_p bigint, cd_convenio_p bigint, cd_categoria_p text, nm_paciente_p text, cd_tipo_acomodacao_p bigint, cd_usuario_convenio_p text, cd_pessoa_fisica_p text, dt_validade_carteira_p text) FROM PUBLIC;
