-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reg_attach_service_order_pr ( nr_seq_service_order_pr_p reg_service_order_pr.nr_sequencia%type, nr_seq_product_requirement_p reg_product_requirement.nr_sequencia%type, nr_seq_object_p reg_product_dic.nr_seq_objeto%type, ie_object_type_p reg_product_dic.ie_tipo_objeto%type, nm_usuario_p reg_product_dic.nm_usuario%type ) AS $body$
BEGIN

	update	reg_service_order_pr
	set	nr_product_requirement = nr_seq_product_requirement_p
	where	nr_sequencia = nr_seq_service_order_pr_p;

	CALL vincular_reg_product_dic(nr_seq_product_requirement_p, nr_seq_object_p, ie_object_type_p, 'N', nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_attach_service_order_pr ( nr_seq_service_order_pr_p reg_service_order_pr.nr_sequencia%type, nr_seq_product_requirement_p reg_product_requirement.nr_sequencia%type, nr_seq_object_p reg_product_dic.nr_seq_objeto%type, ie_object_type_p reg_product_dic.ie_tipo_objeto%type, nm_usuario_p reg_product_dic.nm_usuario%type ) FROM PUBLIC;

