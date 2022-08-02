-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE solucao_rotina_checkclick ( cd_protocolo_p bigint, nr_seq_solucao_p bigint, nr_sequencia_p bigint, qt_dosagem_p INOUT bigint, ie_tipo_dosagem_p INOUT text, ie_questiona_p INOUT text) AS $body$
DECLARE


qt_dosasem_w		bigint	:= 0;
ie_tipo_dosagem_w		varchar(3)	:= '';


BEGIN

select	coalesce(max(ie_questionar_vel_inf),'N'),
	max(ie_tipo_dosagem),
	max(qt_dosagem)
into STRICT	ie_questiona_p,
	ie_tipo_dosagem_w,
	qt_dosasem_w
from	protocolo_medic_solucao
where   cd_protocolo   = cd_protocolo_p
and     nr_seq_solucao = nr_seq_solucao_p
and     nr_sequencia   = nr_sequencia_p;

if ('S' = ie_questiona_p) then
	qt_dosagem_p		:= qt_dosasem_w;
	ie_tipo_dosagem_p		:= ie_tipo_dosagem_w;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE solucao_rotina_checkclick ( cd_protocolo_p bigint, nr_seq_solucao_p bigint, nr_sequencia_p bigint, qt_dosagem_p INOUT bigint, ie_tipo_dosagem_p INOUT text, ie_questiona_p INOUT text) FROM PUBLIC;

