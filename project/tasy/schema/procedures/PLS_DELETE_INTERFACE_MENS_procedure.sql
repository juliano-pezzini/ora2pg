-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_delete_interface_mens (nr_seq_vinculo_est_p text, nr_seq_vinculo_est_tit_p text, nm_usuario_p text) AS $body$
BEGIN

	if (nr_seq_vinculo_est_p IS NOT NULL AND nr_seq_vinculo_est_p::text <> '') then
		DELETE 	FROM w_pls_interface_mens a
		WHERE  	a.nm_usuario = nm_usuario_p
			   AND    coalesce(a.nr_seq_vinculo_est,0) NOT IN (
			   SELECT   coalesce(x.nr_seq_vinculo_est,0)
			   FROM     w_pls_interface_mens x
			   WHERE    x.nm_usuario = nm_usuario_p
			   AND coalesce(x.NR_SEQ_VINCULO_EST,0) IN (nr_seq_vinculo_est_p));
	end if;

	if (nr_seq_vinculo_est_tit_p IS NOT NULL AND nr_seq_vinculo_est_tit_p::text <> '') then
		delete 	from w_pls_interface_mens a
		where  	a.nm_usuario = nm_usuario_p
			and    coalesce(a.nr_seq_vinculo_est_tit,0) not in (
			SELECT   coalesce(x.nr_seq_vinculo_est_tit,0)
			from     w_pls_interface_mens x  where
			x.nm_usuario = nm_usuario_p
			AND coalesce(x.NR_SEQ_VINCULO_EST,0) IN (nr_seq_vinculo_est_tit_p));
	end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_delete_interface_mens (nr_seq_vinculo_est_p text, nr_seq_vinculo_est_tit_p text, nm_usuario_p text) FROM PUBLIC;
