-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_template_chechup_dig ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(250);
qt_reg_w	bigint;
nr_seq_template_w	bigint;


BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

	select	max(nr_seq_template_quest)
	into STRICT	nr_seq_template_w
	from	parametro_medico
	where	cd_estabelecimento	= wheb_usuario_pck.get_cd_Estabelecimento;

	if (nr_seq_template_w IS NOT NULL AND nr_seq_template_w::text <> '') then
		select	count(*)
		into STRICT	qt_reg_w
		from	ehr_registro a,
			ehr_reg_template b
		where	a.nr_sequencia	= b.nr_seq_reg
		and	a.nr_atendimento	= nr_atendimento_p
		and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and	coalesce(a.dt_inativacao::text, '') = ''
		and	b.nr_seq_template	= nr_seq_template_w;

		if (qt_reg_w	> 0) then
			ds_retorno_w	:= wheb_mensagem_pck.get_texto(309947); -- Digitado
		end if;
	end if;

end if;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_template_chechup_dig ( nr_atendimento_p bigint) FROM PUBLIC;

