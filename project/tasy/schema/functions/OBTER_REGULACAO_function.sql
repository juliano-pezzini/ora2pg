-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regulacao ( nr_seq_origem_p bigint, ie_tipo_p text) RETURNS bigint AS $body$
DECLARE

/*
Descrição			ie_tipo_p
Encaminhamento		'E'
Nota clínica		'NC'
Resposta 			'R'
*/
nr_seq_regulacao_w		bigint;


BEGIN
if (nr_seq_origem_p IS NOT NULL AND nr_seq_origem_p::text <> '') then

	if ( ie_tipo_p = 'E') then

		Select  max(a.nr_sequencia)
		into STRICT	nr_seq_regulacao_w
		from	regulacao_atend a,
				atend_encaminhamento b
		where	a.nr_seq_encaminhamento = b.nr_sequencia
		and		b.nr_sequencia = nr_seq_origem_p;


	elsif ( ie_tipo_p = 'NC') then

		Select   max(a.nr_sequencia)
		into STRICT	nr_seq_regulacao_w
		from	regulacao_atend a,
				evolucao_paciente b
		where	a.cd_evolucao_ori = b.cd_evolucao
		and		b.cd_evolucao = nr_seq_origem_p;

	elsif ( ie_tipo_p = 'R') then

		Select  max(a.nr_sequencia)
		into STRICT	nr_seq_regulacao_w
		from	regulacao_atend a,
				parecer_medico b
		where	a.nr_seq_resp_parecer_ori = b.nr_seq_interno
		and		b.nr_seq_interno = nr_seq_origem_p;

	end if;

end if;

return nr_seq_regulacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regulacao ( nr_seq_origem_p bigint, ie_tipo_p text) FROM PUBLIC;
