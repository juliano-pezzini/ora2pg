-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_retorno_convenio_pre (nr_seq_retorno_p convenio_retorno.nr_sequencia%type, cd_convenio_p convenio_retorno.cd_convenio%type, cd_estabelecimento_p convenio_retorno.cd_estabelecimento%type, nm_usuario_p text) AS $body$
DECLARE


    qt_conv_diferente_w integer;
    nr_demonstrativo_w integer;
    qt_reg_demonstrativo_w integer;
    qt_registros_ret_item_w integer;
    ds_guias_outro_ret_w varchar(100);
    saldo_pendente_w varchar(50);
    qt_analisadas_w integer;
    ds_retorno_w varchar(100);
    abort_w varchar(1) := 'N';

    ie_bloqueia_saldo_pendente_w varchar(1);
    ie_avisa_outros_convenios_w varchar(1);
    ie_guias_nao_analisadas_w varchar(1);
    ie_permite_glosa_pendente_w varchar(1);


BEGIN

    ie_bloqueia_saldo_pendente_w := obter_param_usuario(27, 231, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_bloqueia_saldo_pendente_w);
    ie_avisa_outros_convenios_w := obter_param_usuario(27, 134, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_avisa_outros_convenios_w);
    ie_guias_nao_analisadas_w := obter_param_usuario(27, 263, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_guias_nao_analisadas_w);
    ie_permite_glosa_pendente_w := obter_param_usuario(27, 113, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_permite_glosa_pendente_w);

    delete from conv_retorno_validacao where nr_seq_retorno = nr_seq_retorno_p;
    
    if (ie_bloqueia_saldo_pendente_w = 'S') then
         select obter_guias_saldo_pendentes(nr_seq_retorno_p) guia
           into STRICT saldo_pendente_w
;

         if (saldo_pendente_w IS NOT NULL AND saldo_pendente_w::text <> '') then
            CALL insere_conv_retorno_validacao(nr_seq_retorno_p,null,null,null,wheb_mensagem_pck.get_texto(353607,' GUIA='||saldo_pendente_w),null,null,0,0,null,nm_usuario_p,'A');
            abort_w := 'S';
         end if;
     end if;

    if (ie_guias_nao_analisadas_w = 'S') then
        select (select count(*)
            from convenio_retorno_item a
            where a.nr_seq_retorno = nr_seq_retorno_p
            and a.ie_analisada     = 'N'
            ) qt_analisadas
        into STRICT qt_analisadas_w
;

        if (qt_analisadas_w > 0) then
            CALL insere_conv_retorno_validacao(nr_seq_retorno_p,null,null,null,obter_desc_expressao(594981),null,null,0,0,null,nm_usuario_p,'A');
            abort_w := 'S';
        end if;
     end if;

  if (abort_w <> 'S')then
    select	count(*) qt_registros
     into STRICT   qt_conv_diferente_w
    from	conta_paciente b,
            convenio_retorno_item a
    where	a.nr_seq_retorno		= nr_seq_retorno_p--:nr_seq_retorno
      and	a.nr_interno_conta	= b.nr_interno_conta
      and	b.cd_convenio_parametro	<> cd_convenio_p;--:cd_convenio
       select	max(a.nr_sequencia) nr_demonstrativo
         into STRICT   nr_demonstrativo_w
         from	tiss_demonstrativo a,
                tiss_cabecalho b
        where	a.nr_seq_cabecalho	= b.nr_sequencia
          and	b.nr_seq_retorno	= nr_seq_retorno_p;

        --167932
        select  count(*) qt_registros
          into STRICT  qt_reg_demonstrativo_w
          from	tiss_dem_conta a,
                tiss_dem_lote b,
                tiss_dem_fatura c,
                tiss_demonstrativo d
         where	a.nr_seq_lote		= b.nr_sequencia
           and	b.nr_seq_fatura		= c.nr_sequencia
           and	c.nr_seq_demonstrativo	= d.nr_sequencia
           and	coalesce(a.dt_importacao::text, '') = ''
           and	d.nr_sequencia	= nr_demonstrativo_w;

    select	count(*) qt_registros_ret_item
      into STRICT  qt_registros_ret_item_w
      from	convenio_retorno_item
     where	vl_pago = 0
      and	nr_seq_retorno	= nr_seq_retorno_p;

    select	obter_guias_outro_retorno(nr_seq_retorno_p) ds_guias_outro_ret
      into STRICT  ds_guias_outro_ret_w
;

     if (ie_avisa_outros_convenios_w = 'S') and (qt_conv_diferente_w > 0) then
        CALL insere_conv_retorno_validacao(nr_seq_retorno_p,null,null,null,obter_desc_expressao(504404),null,null,0,0,null,nm_usuario_p,'C');
     end if;

     if (qt_reg_demonstrativo_w <> 0) then
        CALL insere_conv_retorno_validacao(nr_seq_retorno_p,null,null,null,obter_desc_expressao(504428),null,null,0,0,null,nm_usuario_p,'C');
     end if;

     if (qt_registros_ret_item_w <> 0) then
        CALL insere_conv_retorno_validacao(nr_seq_retorno_p,null,null,null,obter_desc_expressao(504429),null,null,0,0,null,nm_usuario_p,'C');
     end if;

     if (ds_guias_outro_ret_w IS NOT NULL AND ds_guias_outro_ret_w::text <> '') then
        CALL insere_conv_retorno_validacao(nr_seq_retorno_p,null,null,null,wheb_mensagem_pck.get_texto(167949,'DS_GUIAS='||ds_guias_outro_ret_w),null,null,0,0,null,nm_usuario_p,'C');
     end if;

     if (ie_permite_glosa_pendente_w = 'N') then
        ds_retorno_w := CONSISTIR_RET_GRG(nr_seq_retorno_p, ds_retorno_w);
        if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
            CALL insere_conv_retorno_validacao(nr_seq_retorno_p,null,null,null,ds_retorno_w,null,null,0,0,null,nm_usuario_p,'C');
        end if;
     end if;
  end if;
  commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_retorno_convenio_pre (nr_seq_retorno_p convenio_retorno.nr_sequencia%type, cd_convenio_p convenio_retorno.cd_convenio%type, cd_estabelecimento_p convenio_retorno.cd_estabelecimento%type, nm_usuario_p text) FROM PUBLIC;
