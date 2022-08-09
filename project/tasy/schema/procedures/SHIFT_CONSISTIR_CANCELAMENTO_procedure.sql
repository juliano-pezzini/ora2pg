-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE shift_consistir_cancelamento ( nr_prescricao_p bigint, nr_seq_prescricao_p bigint) AS $body$
DECLARE


ie_retorno_w	varchar(1);


BEGIN

select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_retorno_w
from	prescr_medica a
where	a.nr_prescricao = nr_prescricao_p
and		coalesce(a.nr_controle_lab,'0') <> '0';

if (ie_retorno_w = 'N') then

	CALL wheb_mensagem_pck.exibir_mensagem_abort(820705);

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE shift_consistir_cancelamento ( nr_prescricao_p bigint, nr_seq_prescricao_p bigint) FROM PUBLIC;
