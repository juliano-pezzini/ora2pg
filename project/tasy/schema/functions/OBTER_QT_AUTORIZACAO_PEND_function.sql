-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_autorizacao_pend (nr_atendimento_p bigint, nr_prescricao_p bigint) RETURNS bigint AS $body$
DECLARE


qt_autorizacao_pend_w	bigint;


BEGIN

if (coalesce(nr_atendimento_p,0) > 0) and (coalesce(nr_prescricao_p,0) > 0) then

	 select count(*)
	 into STRICT	qt_autorizacao_pend_w
	 from  autorizacao_convenio b
	 where   b.nr_prescricao = nr_prescricao_p
	 and    b.nr_atendimento = nr_atendimento_p
	 and    obter_estagio_autor(b.nr_seq_estagio,'C') not in (70,10);

end if;

return	qt_autorizacao_pend_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_autorizacao_pend (nr_atendimento_p bigint, nr_prescricao_p bigint) FROM PUBLIC;
