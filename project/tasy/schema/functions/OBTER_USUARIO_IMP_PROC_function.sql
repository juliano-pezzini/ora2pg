-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_usuario_imp_proc ( nr_prescricao_p bigint, nr_seq_prescr_p bigint) RETURNS varchar AS $body$
DECLARE


nr_sequencia_w	bigint;
nm_usuario_w 	varchar(255);


BEGIN


SELECT	MAX(nr_sequencia)
INTO STRICT	nr_sequencia_w
FROM   	lab_prescr_proc_impressao
WHERE  	nr_prescricao = nr_prescricao_p
AND  	nr_seq_prescr = nr_seq_prescr_p
and	ie_mapa_laudo = 'L'
AND	coalesce(ie_tipo_imp,'I')   = 'I';

SELECT	MAX(nm_usuario)
INTO STRICT	nm_usuario_w
FROM   	lab_prescr_proc_impressao
WHERE  	nr_prescricao = nr_prescricao_p
AND  	nr_seq_prescr = nr_seq_prescr_p
and	ie_mapa_laudo = 'L'
and	nr_sequencia = nr_sequencia_w
AND	coalesce(ie_tipo_imp,'I')   = 'I';

RETURN nm_usuario_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_usuario_imp_proc ( nr_prescricao_p bigint, nr_seq_prescr_p bigint) FROM PUBLIC;

