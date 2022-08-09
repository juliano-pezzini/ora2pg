-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_vincular_atend_protocolo ( nr_seq_atendimento_p bigint, nr_seq_segurado_p bigint, nr_protocolo_referencia_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Vincular um protocolo de referência ao atendimento.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ x] Tasy (Delphi/Java) [   ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
qt_protocolo_w			integer	:= 0;
qt_protocolo_segurado_w		integer	:= 0;
qt_protocolo_ref_w		integer	:= 0;
qt_protocolo_atend_w		integer	:= 0;


BEGIN

select	count(1)
into STRICT	qt_protocolo_w
from	pls_protocolo_atendimento
where	nr_protocolo		= nr_protocolo_referencia_p;

select	count(1)
into STRICT	qt_protocolo_segurado_w
from	pls_protocolo_atendimento
where	nr_seq_segurado 	= nr_seq_segurado_p
and	nr_protocolo		= nr_protocolo_referencia_p;

select	count(1)
into STRICT	qt_protocolo_ref_w
from	pls_atendimento
where	nr_sequencia	= nr_seq_atendimento_p
and	(nr_protocolo_referencia IS NOT NULL AND nr_protocolo_referencia::text <> '');

if (qt_protocolo_w = 0) then
	-- Número de protocolo inválido. Favor verificar.
	CALL wheb_mensagem_pck.exibir_mensagem_abort(445814);
elsif (qt_protocolo_segurado_w = 0) then
	-- Este protocolo não existe para este beneficiário.
	CALL wheb_mensagem_pck.exibir_mensagem_abort(445821);
elsif (qt_protocolo_ref_w > 0) then
	--Este atendimento já possui protocolo de referência informado!
	CALL wheb_mensagem_pck.exibir_mensagem_abort(446072);
else
	update	pls_atendimento
	set	nr_protocolo_referencia	= nr_protocolo_referencia_p,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_sequencia		= nr_seq_atendimento_p;

	select	count(1)
	into STRICT	qt_protocolo_atend_w
	from	pls_protocolo_atendimento
	where	nr_seq_atend_pls	= nr_seq_atendimento_p;

	if (qt_protocolo_atend_w > 0) then
		update	pls_protocolo_atendimento
		set	nr_protocolo_referencia	= nr_protocolo_referencia_p,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
		where	nr_seq_atend_pls	= nr_seq_atendimento_p;
	end if;

	CALL pls_gerar_hist_atend_texto(nr_seq_atendimento_p, 1,'Vinculou o atendimento ao protocolo nº '|| nr_protocolo_referencia_p, nm_usuario_p, cd_estabelecimento_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_vincular_atend_protocolo ( nr_seq_atendimento_p bigint, nr_seq_segurado_p bigint, nr_protocolo_referencia_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
