-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION param411_somente_agendados (nr_seq_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_permite_visualizar_w	varchar(1) := 'N';
ie_somente_agendados_w  varchar(1);
qt_agendamento_w    bigint := 0;


BEGIN

ie_somente_agendados_w := Obter_Param_Usuario(3130, 411, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_somente_agendados_w);

if (coalesce(ie_somente_agendados_w,'N') = 'S')	then
	select	count(*)
    into STRICT    qt_agendamento_w
    from	agenda_quimio
    where	nr_seq_atendimento = nr_seq_atendimento_p;
end if;

if ((qt_agendamento_w > 0) or (coalesce(ie_somente_agendados_w,'N') = 'N') ) then
    ie_permite_visualizar_w := 'S';
end if;

return ie_permite_visualizar_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION param411_somente_agendados (nr_seq_atendimento_p bigint) FROM PUBLIC;
