-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE estornar_lib_ordem_compra ( nr_ordem_compra_p bigint, nr_seq_motivo_cancel_p text, ds_observacao_p text, nm_usuario_p text, ie_desvincula_oc_contrato_p text default 'S', ie_descv_adianta_titulo_p text default 'S') AS $body$
DECLARE



cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
nr_seq_aprovacao_w		processo_compra.nr_sequencia%type;
cont_nota_w			integer;
nr_titulo_w			titulo_pagar.nr_titulo%type;
nr_item_oc_venc_w		ordem_compra_venc.nr_item_oc_venc%type;
ie_estorna_aprov_ordem_w	parametro_compras.ie_estorna_aprov_ordem%type;
ie_seq_interna_w		parametro_compras.ie_seq_interna%type;
ds_historico_w			ordem_compra_hist.ds_historico%type;
ds_motivo_w			motivo_estorno_compra.ds_motivo%type;
ie_tipo_ordem_w			ordem_compra.ie_tipo_ordem%type;
nr_seq_contrato_w		contrato.nr_sequencia%type;
cd_perfil_w			perfil.cd_perfil%type;
ie_estorna_baixa_item_sc_w	varchar(1);
nr_solic_compra_w		solic_compra.nr_solic_compra%type;
nr_item_solic_compra_w		solic_compra_item.nr_item_solic_compra%type;
dt_baixa_w			solic_compra.dt_baixa%type;
nr_seq_ordem_adiant_w   ordem_compra_adiant_pago.nr_sequencia%type;
nr_adiantamento_w   adiantamento_pago.nr_adiantamento%type;

c00 CURSOR FOR
SELECT	nr_titulo_pagar,
	nr_item_oc_venc
from	ordem_compra_venc
where	nr_ordem_compra = nr_ordem_compra_p
and	(nr_titulo_pagar IS NOT NULL AND nr_titulo_pagar::text <> '');

c01 CURSOR FOR
SELECT	nr_seq_aprovacao
from	ordem_compra_item
where	nr_ordem_compra	= nr_ordem_compra_p
and	nr_seq_aprovacao > 0;

c02 CURSOR FOR
SELECT	nr_solic_compra,
	nr_item_solic_compra
from	ordem_compra_item
where	nr_ordem_compra = nr_ordem_compra_p
and	nr_solic_compra > 0
and	nr_item_solic_compra > 0
group by nr_solic_compra,
	nr_item_solic_compra;	

c03 CURSOR FOR
SELECT  b.nr_titulo nr_titulo,
        c.nr_sequencia nr_sequencia,
        a.nr_adiantamento nr_adiantamento
FROM ordem_compra_adiant_pago c, adiantamento_pago a
LEFT OUTER JOIN titulo_pagar b ON (a.nr_titulo_original = b.nr_titulo)
WHERE c.nr_adiantamento = a.nr_adiantamento and c.nr_ordem_compra = nr_ordem_compra_p order by  b.ie_situacao desc;


BEGIN

select	cd_estabelecimento,
	ie_tipo_ordem,
	nr_seq_contrato,
	obter_perfil_ativo
into STRICT	cd_estabelecimento_w,
	ie_tipo_ordem_w,
	nr_seq_contrato_w,
	cd_perfil_w
from	ordem_compra
where	nr_ordem_compra	= nr_ordem_compra_p;

select	obter_valor_param_usuario(917, 210, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w)
into STRICT	ie_estorna_baixa_item_sc_w
;

select	coalesce(max(ie_estorna_aprov_ordem), 'S'),
	coalesce(max(ie_seq_interna),'N')
into STRICT	ie_estorna_aprov_ordem_w,
	ie_seq_interna_w
from	parametro_compras
where	cd_estabelecimento = cd_estabelecimento_w;

if (ie_descv_adianta_titulo_p = 'S') then
    open c00;
    loop
    fetch c00 into
        nr_titulo_w,
        nr_item_oc_venc_w;
    EXIT WHEN NOT FOUND; /* apply on c00 */
        begin		

        update	ordem_compra_venc
        set	nr_titulo_pagar	 = NULL
        where	nr_ordem_compra	= nr_ordem_compra_p
        and	nr_item_oc_venc	= nr_item_oc_venc_w;

        /*Foi colocado essa procedure para cancelar o titulo, e nao mais deletar o titulo como era feito antes. Pois estava sendo excluidos titulos ja liquidados, etc etc.
        Essa procedure ja faz todas as consistencias necessarias.*/
        CALL cancelar_titulo_pagar(nr_titulo_w, nm_usuario_p, clock_timestamp());
        end;
    end loop;
    close c00;

    open c03;
    loop
    fetch c03 into
        nr_titulo_w,
        nr_seq_ordem_adiant_w,
        nr_adiantamento_w;
    EXIT WHEN NOT FOUND; /* apply on c03 */
        begin
            if (coalesce(nr_titulo_w::text, '') = '') then
                select max(nr_titulo)
                into STRICT nr_titulo_w 
                from titulo_pagar
                where nr_adiant_pago = nr_adiantamento_w;
            end if;
            if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then
				CALL desvincular_adiant_titulo(nr_adiantamento_w, nr_titulo_w);
                CALL cancelar_titulo_pagar(nr_titulo_w, nm_usuario_p, clock_timestamp());
            end if;
            CALL desvincular_adiant_ord_compra(nr_seq_ordem_adiant_w);
        end;
    end loop;
    close c03;
end if;

select	count(*)
into STRICT	cont_nota_w
from	ordem_compra_nota_fiscal 
where	nr_ordem_compra = nr_ordem_compra_p  LIMIT 1;

if	((ie_estorna_aprov_ordem_w = 'T') or /*Estorna sempre, sem excecao nenhuma*/
	(ie_estorna_aprov_ordem_w = 'S' AND cont_nota_w = 0)) then /*Estorna somente se nao tiver NF*/
		
	update	ordem_compra_item
	set	dt_aprovacao	 = NULL,
		dt_reprovacao	 = NULL
	where	nr_ordem_compra	= nr_ordem_compra_p;

	open C01;
	loop
	fetch C01 into	
		nr_seq_aprovacao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		update	ordem_compra_item
		set	nr_seq_aprovacao	 = NULL,
			dt_aprovacao		 = NULL,
			dt_reprovacao		 = NULL
		where	nr_seq_aprovacao	= nr_seq_aprovacao_w;
	
		delete
		from	processo_aprov_compra
		where	nr_sequencia 	= nr_seq_aprovacao_w;
		
		begin
		delete
		from	processo_compra
		where	nr_sequencia 	= nr_seq_aprovacao_w;
		exception
		when others then
			nr_seq_aprovacao_w := nr_seq_aprovacao_w;
		end;
		end;
	end loop;
	close C01;
	
	delete	from ordem_compra_venc
	where	nr_ordem_compra	= nr_ordem_compra_p;

end if;

update	ordem_compra
set	dt_liberacao	 = NULL,  
	dt_aprovacao	 = NULL,
	nr_seq_motivo_estorno_lib = nr_seq_motivo_cancel_p,
	nm_usuario_estorno_lib = nm_usuario_p,
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp(),
	dt_estorno_lib = clock_timestamp()
where	nr_ordem_compra	= nr_ordem_compra_p;

if (ie_desvincula_oc_contrato_p = 'S') then
	update	ordem_compra
	set	nr_seq_contrato  = NULL
	where	nr_ordem_compra	= nr_ordem_compra_p;
end if;

if (ie_seq_interna_w = 'Z') then
	update	ordem_compra
	set	nr_seq_interno	 = NULL
	where	nr_ordem_compra	= nr_ordem_compra_p;
end if;

if (coalesce(ie_tipo_ordem_w,'N') = 'T') then
	begin
	ds_historico_w	:= substr(Wheb_mensagem_pck.get_Texto(300818),1,4000); /*'Para essa solicitacao de transferencia, foi estornado a liberacao.*/
	CALL gerar_comunic_solic_transf(nr_ordem_compra_p,null,31,nm_usuario_p);
	CALL gerar_email_solic_transf(nr_ordem_compra_p,null,41,nm_usuario_p);
	end;
else
	ds_historico_w	:= substr(Wheb_mensagem_pck.get_Texto(300819),1,4000); /*Para essa ordem de compra, foi estornado a liberacao.*/
end if;

if (nr_seq_motivo_cancel_p IS NOT NULL AND nr_seq_motivo_cancel_p::text <> '') then
	select	ds_motivo
	into STRICT	ds_motivo_w
	from	motivo_estorno_compra
	where	nr_sequencia	= nr_seq_motivo_cancel_p;

	ds_historico_w := 	substr(WHEB_MENSAGEM_PCK.get_texto(300820,'DS_HISTORICO_W='|| DS_HISTORICO_W ||';DS_MOTIVO_W='|| DS_MOTIVO_W ||';DS_OBSERVACAO_P='|| DS_OBSERVACAO_P ),1,4000);
				/*#@DS_HISTORICO_W#@
				Motivo: #@DS_MOTIVO_W#@
				Observacao: #@DS_OBSERVACAO_P#@*/
end if;

if	(nr_seq_contrato_w > 0 AND ie_desvincula_oc_contrato_p = 'S') then
	ds_historico_w := substr(WHEB_MENSAGEM_PCK.get_texto(300821,'DS_HISTORICO_W='|| DS_HISTORICO_W ||';NR_SEQ_CONTRATO_W='|| NR_SEQ_CONTRATO_W),1,4000);
			/*#@DS_HISTORICO_W#@
			A ordem tambem foi desvinculada do contrato #@NR_SEQ_CONTRATO_W#@.*/
end if;

CALL inserir_historico_ordem_compra(
	nr_ordem_compra_p,
	'S',
	Wheb_mensagem_pck.get_Texto(300822),
	ds_historico_w,
	nm_usuario_p);

CALL sup_cancela_email_pendente(null,nr_ordem_compra_p,'OC',cd_estabelecimento_w,nm_usuario_p);


if (ie_estorna_baixa_item_sc_w = 'S') then

	open C02;
	loop
	fetch C02 into	
		nr_solic_compra_w,
		nr_item_solic_compra_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		update	solic_compra_item
		set	cd_motivo_baixa		 = NULL,
			dt_baixa		 = NULL
		where	nr_solic_compra		= nr_solic_compra_w
		and	nr_item_solic_compra	= nr_item_solic_compra_w;
		
		CALL gerar_historico_solic_compra(	nr_solic_compra_w,
			Wheb_mensagem_pck.get_Texto(300823), /*'Estorno da baixa do item da solicitacao de compras',*/
			WHEB_MENSAGEM_PCK.get_texto(300824,'NR_ITEM_SOLIC_COMPRA_W='|| NR_ITEM_SOLIC_COMPRA_W ||';NR_ORDEM_COMPRA_P='|| NR_ORDEM_COMPRA_P), /*'Foi estornado a baixa do item ' || nr_item_solic_compra_w || ' atraves do estorno da ordem de compra ' || nr_ordem_compra_p || '.',*/
			'T',
			nm_usuario_p);		
		
		select	dt_baixa
		into STRICT	dt_baixa_w
		from	solic_compra
		where	nr_solic_compra		= nr_solic_compra_w;
		
		if (dt_baixa_w IS NOT NULL AND dt_baixa_w::text <> '') then
		
			update	solic_compra
			set	cd_motivo_baixa		 = NULL,
				dt_baixa		 = NULL
			where	nr_solic_compra		= nr_solic_compra_w;
			
			CALL gerar_historico_solic_compra(	nr_solic_compra_w,
				Wheb_mensagem_pck.get_Texto(300825), /*'Estorno da baixa da solicitacao de compras',*/
				Wheb_mensagem_pck.get_Texto(300826, 'NR_ORDEM_COMPRA_P='||NR_ORDEM_COMPRA_P),/*'Foi estornado a baixa da solicitacao atraves do estorno da ordem de compra ' || NR_ORDEM_COMPRA_P || '.',*/
				'T',
				nm_usuario_p);		
		end if;
		end;
	end loop;
	close C02;
end if;	

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE estornar_lib_ordem_compra ( nr_ordem_compra_p bigint, nr_seq_motivo_cancel_p text, ds_observacao_p text, nm_usuario_p text, ie_desvincula_oc_contrato_p text default 'S', ie_descv_adianta_titulo_p text default 'S') FROM PUBLIC;

