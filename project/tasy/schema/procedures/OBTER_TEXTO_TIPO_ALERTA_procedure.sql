-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_texto_tipo_alerta ( nr_seq_tipo_alerta_p bigint, ds_texto_padrao_p INOUT text, nr_seq_default_option_p INOUT bigint, ie_allow_free_text_p INOUT text) AS $body$
DECLARE


ds_texto_padrao_w		varchar(2000) := '';
nr_seq_default_option_w bigint := 0;
ie_allow_free_text_w 	varchar(1) := 'Y';

BEGIN
select	max(coalesce(ie_allow_free_text, 'Y')),
	max(nr_seq_default_option),
	max(substr(ds_texto_padrao,1,2000))
into STRICT	ie_allow_free_text_w,
	nr_seq_default_option_w,
	ds_texto_padrao_w
from	tipo_alerta_atend
where	nr_sequencia = nr_seq_tipo_alerta_p;

ds_texto_padrao_p		:= ds_texto_padrao_w;
nr_seq_default_option_p := nr_seq_default_option_w;
ie_allow_free_text_p 	:= ie_allow_free_text_w;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_texto_tipo_alerta ( nr_seq_tipo_alerta_p bigint, ds_texto_padrao_p INOUT text, nr_seq_default_option_p INOUT bigint, ie_allow_free_text_p INOUT text) FROM PUBLIC;

