-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exame_laudo_lib ( nr_atendimento_p prescr_medica.nr_atendimento%TYPE) RETURNS varchar AS $body$
DECLARE


qt_exame_w		        bigint;
qt_exame_laudo_lib_w	bigint;
ds_retorno_w		    varchar(2);
ds_result_exames_w	    varchar(1);

/*
P  -  Exame liberado e pendente por fazer	
PL - Exame liberado e pendente de liberacao de laudo
S -  Exame liberado e laudo liberado
N  - Nao tem exame liberado para o paciente
NP - Nao tem exame com laudo
*/
BEGIN

select	Obter_se_exame_lib_exames(nr_atendimento_p)
into STRICT	ds_result_exames_w
;


if (ds_result_exames_w = 'S') then

	select	count(*)
    into STRICT	qt_exame_w
    from	prescr_procedimento b,
            prescr_medica a
    where	a.nr_prescricao  = b.nr_prescricao
    and	a.nr_atendimento = nr_atendimento_p
    and	coalesce(b.nr_seq_exame::text, '') = ''
    and	coalesce(a.dt_suspensao::text, '') = ''
    and coalesce(b.dt_suspensao::text, '') = ''
    and ((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') or (a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> ''));

	select	count(*)
	into STRICT	qt_exame_laudo_lib_w
	from 	prescr_procedimento d,
		prescr_medica c,
		pessoa_fisica d,
		atendimento_paciente_v b,
		laudo_paciente a
	where	a.nr_atendimento	= b.nr_atendimento
	and	b.nr_atendimento	= nr_atendimento_p
	and	a.nr_prescricao		= c.nr_prescricao
	and	d.nr_prescricao		= c.nr_prescricao
	and	d.nr_sequencia		= a.nr_seq_prescricao
	and	b.cd_pessoa_fisica	= d.cd_pessoa_fisica
	and	a.ie_status_laudo	= 'LL'
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '');

	if (qt_exame_laudo_lib_w < qt_exame_w ) and ( qt_exame_laudo_lib_w <> 0 ) then
		ds_retorno_w := 'PL';
	else
		if ( qt_exame_laudo_lib_w = qt_exame_w) and (qt_exame_w <> 0) then
			ds_retorno_w := 'S';
		else
			ds_retorno_w := 'NP';
		end if;
	end if;

else

	ds_retorno_w := ds_result_exames_w;		
	
end if;

RETURN	ds_retorno_w;

END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exame_laudo_lib ( nr_atendimento_p prescr_medica.nr_atendimento%TYPE) FROM PUBLIC;

