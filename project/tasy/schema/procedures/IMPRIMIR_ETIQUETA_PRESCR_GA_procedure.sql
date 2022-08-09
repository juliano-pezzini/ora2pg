-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE imprimir_etiqueta_prescr_ga ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_status_p text, nm_usuario_p text, ds_status_atual_p INOUT text, ds_status_param_p INOUT text) AS $body$
DECLARE


nr_seq_status_pato_w	bigint;
ds_status_atual_w		varchar(255) := '';
ds_status_param_w		varchar(255) := '';


BEGIN

select 	max(nr_seq_status_pato)
into STRICT	nr_seq_status_pato_w
from   	prescr_procedimento
where  	nr_prescricao = nr_prescricao_p
and	nr_sequencia  = nr_seq_prescr_p;

select 	max(ds_status)
into STRICT	ds_status_atual_w
from 	proced_patologia_status
where  	nr_sequencia = nr_seq_status_pato_w;

select (ds_status)
into STRICT	ds_status_param_w
from 	proced_patologia_status
where  	nr_sequencia = ie_status_p;

ds_status_atual_p := ds_status_atual_w;
ds_status_param_p := ds_status_param_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE imprimir_etiqueta_prescr_ga ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_status_p text, nm_usuario_p text, ds_status_atual_p INOUT text, ds_status_param_p INOUT text) FROM PUBLIC;
