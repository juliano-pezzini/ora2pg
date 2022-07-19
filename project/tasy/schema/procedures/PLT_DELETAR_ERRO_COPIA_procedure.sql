-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE plt_deletar_erro_copia ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_tipo_item_p text, ie_motivo_p text, nm_usuario_p text) AS $body$
BEGIN

delete	FROM w_copia_plano
where	nr_prescricao	= nr_prescricao_p
and	nr_seq_item	= nr_sequencia_p
and	ie_tipo_item	= ie_tipo_item_p
and	ie_motivo	in (ie_motivo_p)
and	nm_usuario	= nm_usuario_p;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE plt_deletar_erro_copia ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_tipo_item_p text, ie_motivo_p text, nm_usuario_p text) FROM PUBLIC;

