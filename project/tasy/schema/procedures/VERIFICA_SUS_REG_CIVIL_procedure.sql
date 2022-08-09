-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verifica_sus_reg_civil ( nr_interno_conta_p bigint, ie_reg_civil_p INOUT text) AS $body$
DECLARE

 
nr_atendimento_w	bigint;
ie_reg_civil_w		varchar(1)	:= 'S';
qt_proced_w		bigint	:= 0;
qt_reg_civil_w		bigint	:= 0;


BEGIN 
 
select	nr_atendimento 
into STRICT	nr_atendimento_w 
from	conta_paciente 
where	nr_interno_conta	= nr_interno_conta_p;
 
select	count(*) 
into STRICT	qt_proced_w 
from	procedimento_paciente 
where	nr_interno_conta	= nr_interno_conta_p 
and	ie_origem_proced	= 2 
and	cd_procedimento	in ( 
	35001011,35006013,35007010,35023015,35027010,35025018,35080019, 35021012,35024011, 
	35009012,35022019,35026014,35028017,35082011,35084014,35083018,35085010) 
and	coalesce(cd_motivo_exc_conta::text, '') = '';
 
select	count(*) 
into STRICT	qt_reg_civil_w 
from	sus_aih_reg_civil 
where	nr_atendimento	= nr_atendimento_w;
 
if (qt_proced_w	> 0) and (qt_reg_civil_w	= 0) then 
	ie_reg_civil_w	:= 'N';
end if;
 
ie_reg_civil_p	:= ie_reg_civil_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verifica_sus_reg_civil ( nr_interno_conta_p bigint, ie_reg_civil_p INOUT text) FROM PUBLIC;
