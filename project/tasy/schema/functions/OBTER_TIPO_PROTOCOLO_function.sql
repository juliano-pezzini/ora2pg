-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_protocolo (nr_seq_protocolo_p bigint) RETURNS bigint AS $body$
DECLARE


ie_tipo_protocolo_w smallint;


BEGIN

select     max(ie_tipo_protocolo)
into STRICT       ie_tipo_protocolo_w
from       protocolo_convenio
where      nr_seq_protocolo = nr_seq_protocolo_p;

return ie_tipo_protocolo_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_protocolo (nr_seq_protocolo_p bigint) FROM PUBLIC;
