-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_repasse_segurado ( nr_seq_seg_repasse_p bigint, ie_commit_p text, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE

			
nr_seq_segurado_w		bigint;
dt_repasse_w			timestamp;
nr_seq_congenere_w		bigint;
qt_registros_w			bigint;
ds_erro_w			varchar(255);
ie_tipo_contrato_w		varchar(10);
nr_seq_intercambio_w		bigint;
ie_tipo_segurado_w		varchar(10);
ie_tipo_compartilhamento_w	pls_segurado_repasse.ie_tipo_compartilhamento%type;
nr_seq_contrato_w		pls_contrato.nr_sequencia%type;
ie_tipo_operacao_w		pls_contrato.ie_tipo_operacao%type;


BEGIN

select	nr_seq_segurado,
	dt_repasse,
	nr_seq_congenere,
	ie_tipo_compartilhamento
into STRICT	nr_seq_segurado_w,
	dt_repasse_w,
	nr_seq_congenere_w,
	ie_tipo_compartilhamento_w
from	pls_segurado_repasse
where	nr_sequencia	= nr_seq_seg_repasse_p;

select	count(*)
into STRICT	qt_registros_w
from	pls_congenere		d,
	ptu_intercambio_benef	c,
	ptu_intercambio_empresa	b,
	ptu_intercambio		a
where	c.nr_seq_empresa		= b.nr_sequencia
and	b.nr_seq_intercambio		= a.nr_sequencia
and	c.nr_seq_segurado		= nr_seq_segurado_w
and	a.ie_operacao			= 'E'
and	trunc(c.dt_repasse,'dd') 	= trunc(dt_repasse_w,'dd')
and	(d.cd_cooperativa)::numeric 	= (a.cd_unimed_destino)::numeric
and	d.nr_sequencia			= nr_seq_congenere_w;

if (qt_registros_w = 0) then
	update	pls_segurado_repasse
	set	dt_liberacao	 = NULL,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_seq_seg_repasse_p;
	
	if (ie_tipo_compartilhamento_w = 1) then
		ie_tipo_segurado_w	:= 'B';

		select	max(nr_seq_intercambio),
			max(nr_seq_contrato)
		into STRICT	nr_seq_intercambio_w,
			nr_seq_contrato_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_segurado_w;
	
		if (nr_seq_intercambio_w IS NOT NULL AND nr_seq_intercambio_w::text <> '') then
			select	ie_tipo_contrato
			into STRICT	ie_tipo_contrato_w
			from	pls_intercambio
			where	nr_sequencia	= nr_seq_intercambio_w;
			
			if (ie_tipo_contrato_w	= 'C') then
				ie_tipo_segurado_w	:= 'C';
			else
				ie_tipo_segurado_w	:= 'T';
			end if;	
		elsif (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then
			select	max(ie_tipo_operacao)
			into STRICT	ie_tipo_operacao_w
			from	pls_contrato
			where	nr_sequencia = nr_seq_contrato_w;
			
			if (ie_tipo_operacao_w = 'A') then
				ie_tipo_segurado_w	:= ie_tipo_operacao_w;
			end if;
		end if;	

		update	pls_segurado
		set	ie_tipo_segurado	= ie_tipo_segurado_w,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			dt_alteracao_tipo_segurado = CASE WHEN ie_tipo_segurado=ie_tipo_segurado_w THEN  dt_alteracao_tipo_segurado  ELSE trunc(clock_timestamp(),'dd') END
		where	nr_sequencia		= nr_seq_segurado_w;
	end if;

	CALL pls_gerar_segurado_historico(	nr_seq_segurado_w, '52', clock_timestamp(), wheb_mensagem_pck.get_texto(280358),
					'pls_desfazer_repasse_segurado', null, null, null,
					null, null, null, null,
					null, null, null, null,
					nm_usuario_p, 'N');			
else
	ds_erro_w	:= wheb_mensagem_pck.get_texto(280361);
end if;

ds_erro_p	:= ds_erro_w;

if (ie_commit_p = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_repasse_segurado ( nr_seq_seg_repasse_p bigint, ie_commit_p text, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
