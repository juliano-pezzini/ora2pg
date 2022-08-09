-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE block_batch_ap_lote_bloqueio ( nr_seq_lote_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_block_reason_p text, ds_error_p INOUT text) AS $body$
DECLARE

/* This procedure has been written as part of SATH requirement SO. At the time of development this requirement is specific to Australia  locale.
This procedure check if a batch is blocked for a given user. If the batch is not blocked then place the batch on hold for all other users.
This will not depend on the time configuration.
*/
nr_sequencia_w		bigint;
nm_usuario_w		varchar(15);
dt_atualizacao_w		timestamp;
dt_tentativa_w		timestamp;
ie_bloqueado_w		varchar(1);
ie_explicit_hold_w	varchar(1);
IE_MANUAL_HOLD_BY_USER_W varchar(1);
ds_reason_w         varchar(255);


BEGIN

ie_bloqueado_w	:= 'N';
ie_explicit_hold_w := 'S';
IE_MANUAL_HOLD_BY_USER_W := 'S';
dt_tentativa_w := clock_timestamp();

/*Check why this delete block is there */

/*  delete
	from	ap_lote_bloqueio
	where	nm_usuario	= nm_usuario_p
	and	nr_seq_lote	<> nr_seq_lote_p;*/
	select	coalesce(max(nr_sequencia), 0)
	into STRICT	nr_sequencia_w
	from	ap_lote_bloqueio
	where	nr_seq_lote	= nr_seq_lote_p;

  if (nr_sequencia_w = 0) then

		insert into ap_lote_bloqueio(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_lote,
			ds_block_reason,
      IE_MANUAL_HOLD_BY_USER,
			ie_explicit_hold)
		values (	nextval('ap_lote_bloqueio_seq'),
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_lote_p,
			ds_block_reason_p,
      IE_MANUAL_HOLD_BY_USER_W,
			ie_explicit_hold_w);

		ie_bloqueado_w	:= 'N';
	else
		begin

		select	nm_usuario,
			dt_atualizacao,
			ds_block_reason
		into STRICT	nm_usuario_w,
			dt_atualizacao_w,
		    ds_reason_w
		from	ap_lote_bloqueio
		where	nr_sequencia	= nr_sequencia_w;

		if (nm_usuario_w = nm_usuario_p) then

			update	ap_lote_bloqueio
			set	dt_atualizacao	= clock_timestamp() , ie_explicit_hold = ie_explicit_hold_w , IE_MANUAL_HOLD_BY_USER = IE_MANUAL_HOLD_BY_USER_W
			where	nr_sequencia	= nr_sequencia_w;

			ie_bloqueado_w	:= 'N';

		elsif (nm_usuario_w <> nm_usuario_p) then
			begin

			/*dt_tentativa_w		:= sysdate;
			qt_min_diferenca_w	:= ((dt_tentativa_w - dt_atualizacao_w) * 1440);


			if	(qt_min_diferenca_w < qt_min_controle_lote_w) then
				ie_bloqueado_w	:= 'S';
			else
				update	ap_lote_bloqueio
				set	nm_usuario	= nm_usuario_p,
					dt_atualizacao	= dt_tentativa_w
				where	nr_sequencia	= nr_sequencia_w;

				ie_bloqueado_w	:= 'N';
			end if;*/
    ie_bloqueado_w	:= 'S';
			end;
		end if;
		end;
	end if;
if (ie_bloqueado_w = 'S') then
	ds_error_p		:= WHEB_MENSAGEM_PCK.get_texto(281142) || ' ' || nm_usuario_w || '!' ||  chr(10) || chr(13) ||
				WHEB_MENSAGEM_PCK.get_texto(281143) || to_char(dt_atualizacao_w,'dd/mm/yyyy hh24:mi:ss') || chr(13) || chr(10) ||
				WHEB_MENSAGEM_PCK.get_texto(281144) || to_char(dt_tentativa_w, 'dd/mm/yyyy hh24:mi:ss') || chr(13) || chr(10)||
				WHEB_MENSAGEM_PCK.get_texto(333891) || ' ' || ds_reason_w; -- || ' ' ||chr(13) || chr(10)||
		--		WHEB_MENSAGEM_PCK.get_texto(281145) || qt_min_controle_lote_w || WHEB_MENSAGEM_PCK.get_texto(281146);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE block_batch_ap_lote_bloqueio ( nr_seq_lote_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_block_reason_p text, ds_error_p INOUT text) FROM PUBLIC;
