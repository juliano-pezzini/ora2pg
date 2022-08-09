-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_scor_ida_deri_apach_md (qt_idade_p bigint, qt_pt_idade1_p INOUT bigint, qt_pt_idade2_p INOUT bigint, qt_pt_idade3_p INOUT bigint, qt_pt_idade4_p INOUT bigint, qt_pt_idade5_p INOUT bigint ) AS $body$
DECLARE


	qt_pt_idade1_w	 bigint;
	qt_pt_idade2_w	 bigint;
	qt_pt_idade3_w	 bigint;
	qt_pt_idade4_w	 bigint;
	qt_pt_idade5_w	 bigint;

BEGIN
	if	((qt_idade_p - 27) > 0) then
		qt_pt_idade1_w	:=	power((qt_idade_p - 27), 3);
	end if;
	if	((qt_idade_p - 51) > 0) then
		qt_pt_idade2_w	:=	power((qt_idade_p - 51), 3);
	end if;
	if	((qt_idade_p - 64) > 0) then
		qt_pt_idade3_w	:=	power((qt_idade_p - 64), 3);
	end if;
	if	((qt_idade_p - 74) > 0) then
		qt_pt_idade4_w	:=	power((qt_idade_p - 74), 3);
	end if;
	if	((qt_idade_p - 86) > 0) then
		qt_pt_idade5_w	:=	power((qt_idade_p - 86), 3);
	end if;

	qt_pt_idade1_p   := coalesce(qt_pt_idade1_w,0);
	qt_pt_idade2_p   := coalesce(qt_pt_idade2_w,0);
	qt_pt_idade3_p   := coalesce(qt_pt_idade3_w,0);
	qt_pt_idade4_p   := coalesce(qt_pt_idade4_w,0);
	qt_pt_idade5_p   := coalesce(qt_pt_idade5_w,0);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_scor_ida_deri_apach_md (qt_idade_p bigint, qt_pt_idade1_p INOUT bigint, qt_pt_idade2_p INOUT bigint, qt_pt_idade3_p INOUT bigint, qt_pt_idade4_p INOUT bigint, qt_pt_idade5_p INOUT bigint ) FROM PUBLIC;
