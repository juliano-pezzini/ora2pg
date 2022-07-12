-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_classif_comunic ( ie_tipo_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_classif_w		bigint;


BEGIN

Select min(nr_sequencia)
into STRICT	nr_seq_classif_w
from	comunic_interna_classif
where	ie_tipo	= ie_tipo_p;

return nr_seq_classif_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_classif_comunic ( ie_tipo_p text) FROM PUBLIC;

