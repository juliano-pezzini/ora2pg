-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE eme_cancela_faturamento ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_chamado_hist_fat_w		bigint;
nr_seq_chamado_w		eme_chamado.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	eme_chamado
	where	nr_seq_faturamento = nr_sequencia_p;


BEGIN

select  max(nr_sequencia)
into STRICT    nr_seq_chamado_w
from    eme_chamado
where   nr_seq_faturamento = nr_sequencia_p;

update  eme_faturamento
set     nm_usuario_cancelamento = nm_usuario_p,
dt_cancelamento         = clock_timestamp()
where   nr_sequencia            = nr_sequencia_p;

open c01;
loop
fetch c01 into
nr_seq_chamado_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
begin

	update	eme_chamado
	set	nr_seq_faturamento 	 = NULL,
		ie_faturamento 		= 'S'
	where	nr_sequencia = nr_seq_chamado_w;

	SELECT	nextval('eme_chamado_hist_fat_seq')
	INTO STRICT	nr_chamado_hist_fat_w
	;

	INSERT	INTO eme_chamado_hist_fat(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		ie_operacao,
		dt_operacao,
		nr_seq_faturamento,
		nr_seq_chamado)
	VALUES (
		nr_chamado_hist_fat_w,
		clock_timestamp(),
		nm_usuario_p,
		'C',
		clock_timestamp(),
		nr_sequencia_p,
		nr_seq_chamado_w);

end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eme_cancela_faturamento ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
