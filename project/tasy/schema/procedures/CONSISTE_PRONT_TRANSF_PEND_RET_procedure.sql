-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_pront_transf_pend_ret ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_Seq_recebimento_p INOUT text) AS $body$
DECLARE


qt_recebimento_w	bigint:= 0;
nr_prontuario_w		bigint;
nr_Seq_recebimento_w	bigint;


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then

	select	max(nr_sequencia)
	into STRICT	nr_Seq_recebimento_w
	from	transf_prontuario
	where	coalesce(dt_recebimento::text, '') = ''
	and	coalesce(dt_cancelamento::text, '') = ''
	and	cd_pessoa_fisica 	= cd_pessoa_fisica_p
	--and	((dt_periodo_inicial is null) or (dt_periodo_inicial	= dt_periodo_inicial_p))
	and	((nr_atendimento_p 	= 0) or (nr_atendimento	= nr_atendimento_p));

	if (nr_Seq_recebimento_w IS NOT NULL AND nr_Seq_recebimento_w::text <> '') then
		nr_Seq_recebimento_p	:= nr_Seq_recebimento_w;
	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_pront_transf_pend_ret ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_Seq_recebimento_p INOUT text) FROM PUBLIC;

