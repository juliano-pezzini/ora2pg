-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_regra_ped_exame (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE



ie_retorno_w               varchar(10);


cd_procedimento_w	   bigint;
nr_seq_proc_interno_w	   bigint;
ie_origem_proced_w	   bigint;
nr_seq_exame_lab_w         bigint;

qt_regra_exames_w	   bigint;





BEGIN

qt_regra_exames_w    := 0;

if (nr_sequencia_P IS NOT NULL AND nr_sequencia_P::text <> '') then

	select count(*)
	into STRICT   qt_regra_exames_w
	from   regra_pedido_exame_externo;

	if (qt_regra_exames_w > 0) then

		select 	max(c.nr_proc_interno),
			max(a.ie_origem_proced),
			max(a.cd_procedimento),
			max(nr_seq_exame_lab)
		into STRICT	nr_seq_proc_interno_w,
			ie_origem_proced_w,
			cd_procedimento_w,
			nr_seq_exame_lab_w
		from	pedido_exame_externo_item c,
			estrutura_procedimento_v a
		where	c.cd_procedimento = a.cd_procedimento
		and	c.ie_origem_proced = a.ie_origem_proced
		and     c.nr_sequencia = nr_sequencia_p;


		SELECT coalesce(MAX('S'),'N')
		into STRICT 	ie_retorno_w
		from	regra_pedido_exame_externo
		where   coalesce(cd_procedimento, cd_procedimento_w)			= cd_procedimento_w
		and	coalesce(ie_origem_proced, ie_origem_proced_w)		= ie_origem_proced_w
		and	coalesce(nr_seq_proc_interno,coalesce(nr_seq_proc_interno_w,0))	= coalesce(nr_seq_proc_interno_w,0)
		and     coalesce(nr_seq_exame, nr_seq_exame_lab_w)               = nr_seq_exame_lab_w;

	else
		ie_retorno_w := 'S';
	end if;

end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_regra_ped_exame (nr_sequencia_p bigint) FROM PUBLIC;

