-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reg_change_req_situation ( nr_seq_requirement_p bigint, ie_requirement_type_p text, ie_situation_p text, ds_reason_p text, nm_usuario_p text ) AS $body$
BEGIN

if (ie_requirement_type_p = 'C') then

	if (ie_situation_p = 'A') then

		update	reg_customer_requirement
		set	ie_situacao = ie_situation_p,
			dt_inativacao  = NULL,
			nm_usuario_inativacao  = NULL,
			ds_motivo_inativacao  = NULL,
			dt_aprovacao  = NULL,
			nm_usuario_aprovacao  = NULL,
			dt_liberacao  = NULL,
			nm_usuario_liberacao  = NULL
		where	nr_sequencia = nr_seq_requirement_p;

	elsif (ie_situation_p = 'I') then

		update	reg_customer_requirement
		set	ie_situacao = ie_situation_p,
			dt_inativacao = clock_timestamp(),
			nm_usuario_inativacao = nm_usuario_p,
			ds_motivo_inativacao = ds_reason_p
		where	nr_sequencia = nr_seq_requirement_p;

	end if;

elsif (ie_requirement_type_p = 'P') then

	if (ie_situation_p = 'A') then

		update	reg_product_requirement
		set	ie_situacao = ie_situation_p,
			dt_inativacao  = NULL,
			nm_usuario_inativacao  = NULL,
			ds_motivo_inativacao  = NULL,
			dt_aprovacao  = NULL,
			nm_usuario_aprovacao  = NULL,
			dt_liberacao_dev  = NULL,
			nm_analista_liberou  = NULL,
			dt_liberacao  = NULL,
			nm_usuario_liberacao  = NULL
		where	nr_sequencia = nr_seq_requirement_p;

	elsif (ie_situation_p = 'I') then

		update	reg_product_requirement
		set	ie_situacao = ie_situation_p,
			dt_inativacao = clock_timestamp(),
			nm_usuario_inativacao = nm_usuario_p,
			ds_motivo_inativacao = ds_reason_p
		where	nr_sequencia = nr_seq_requirement_p;

	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_change_req_situation ( nr_seq_requirement_p bigint, ie_requirement_type_p text, ie_situation_p text, ds_reason_p text, nm_usuario_p text ) FROM PUBLIC;
