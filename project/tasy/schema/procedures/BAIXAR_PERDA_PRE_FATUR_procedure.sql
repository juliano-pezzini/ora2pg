-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixar_perda_pre_fatur ( nr_seq_perda_p bigint, ie_operacao_p text, nm_usuario_p text) AS $body$
DECLARE


qt_registro_w			bigint;
nr_interno_conta_w		bigint;

c01 CURSOR FOR
SELECT	a.nr_interno_conta
from	pre_fatur_perda_conta a
where	a.nr_seq_perda	= nr_seq_perda_p;


BEGIN

if (ie_operacao_p = 'B') then

	update 	pre_fatur_perda
	set 	dt_baixa   	= clock_timestamp(),
		nm_usuario 	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where 	nr_sequencia 	= nr_seq_perda_p;

else

	select	count(*)
	into STRICT	qt_registro_w
	from	pre_fatur_perda_conta
	where	nr_seq_perda	= nr_seq_perda_p
	and	(nr_lote_contabil IS NOT NULL AND nr_lote_contabil::text <> '');

	if (qt_registro_w > 0) then
		CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(280125);
	end if;

	update 	pre_fatur_perda
	set 	dt_baixa   	 = NULL,
		nm_usuario 	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where 	nr_sequencia 	= nr_seq_perda_p;

end if;

/* ahoffelder - OS 262667 - 07/03/2011 - alterar o status do repasse */

open	c01;
loop
fetch	c01 into
	nr_interno_conta_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	CALL gerar_perdas_repasse(nr_interno_conta_w,nm_usuario_p,ie_operacao_p);

end	loop;
close	c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixar_perda_pre_fatur ( nr_seq_perda_p bigint, ie_operacao_p text, nm_usuario_p text) FROM PUBLIC;
